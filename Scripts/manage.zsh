#!/bin/zsh
set -euo pipefail

readonly source_root="${0:A:h:h}"
readonly operation_name="${1:-status}"
readonly language_name="${2:-en}"
readonly user_library_dir="${HOME}/Library"
readonly screenshot_dir="${HOME}/Desktop/截屏"
readonly support_dir="${user_library_dir}/Application Support/SnapKeep"
readonly state_file="${support_dir}/state.plist"
readonly action_dir="${user_library_dir}/Scripts/Folder Action Scripts"
readonly action_file="${action_dir}/SnapKeep - Screenshot to Clipboard.scpt"
readonly preference_domain="io.github.tont-wilshere.snapkeep"

read_state() { /usr/libexec/PlistBuddy -c "Print :$1" "${state_file}" 2>/dev/null; }

case "${operation_name}" in
install)
	/bin/mkdir -p "${screenshot_dir}" "${support_dir}" "${action_dir}"
	# Preserve the first pre-install values across reinstall/upgrade.
	if [[ ! -e "${state_file}" ]]; then
		/usr/bin/plutil -create xml1 "${state_file}"
		/usr/bin/plutil -insert screenshotPath -string "${screenshot_dir}" "${state_file}"
		for preference_key in location location-last target; do
			if preference_value=$(/usr/bin/defaults read com.apple.screencapture "${preference_key}" 2>/dev/null); then
				/usr/bin/plutil -insert "${preference_key}" -string "${preference_value}" "${state_file}"
			fi
		done
	fi
	/usr/bin/osacompile -o "${support_dir}/action-next.scpt" "${source_root}/Sources/folder-action.applescript"
	/bin/mv -f "${support_dir}/action-next.scpt" "${action_file}"
	/usr/bin/osascript "${source_root}/Sources/folder-settings.applescript" install "${screenshot_dir}"
	/usr/bin/defaults write com.apple.screencapture location -string "${screenshot_dir}"
	/usr/bin/defaults write com.apple.screencapture location-last -string "${screenshot_dir}"
	/usr/bin/defaults write com.apple.screencapture target -string file
	/usr/bin/defaults write "${preference_domain}" language -string "${language_name}"
	/usr/bin/defaults write "${preference_domain}" installed -bool true
	/usr/bin/killall SystemUIServer 2>/dev/null || true
	echo installed
	;;
uninstall)
	/usr/bin/osascript "${source_root}/Sources/folder-settings.applescript" uninstall "${screenshot_dir}"
	# Restore saved settings only while the destination is still managed by us.
	current_location=$(/usr/bin/defaults read com.apple.screencapture location 2>/dev/null || true)
	if [[ -f "${state_file}" ]] && [[ "${current_location}" == "${screenshot_dir}" || "${current_location}" == '~/Desktop/截屏' ]]; then
		for preference_key in location location-last target; do
			if preference_value=$(read_state "${preference_key}"); then
				/usr/bin/defaults write com.apple.screencapture "${preference_key}" -string "${preference_value}"
			else
				/usr/bin/defaults delete com.apple.screencapture "${preference_key}" 2>/dev/null || true
			fi
		done
	fi
	# Exact helper/state files only. Screenshots and unrelated folder actions are retained.
	[[ ! -f "${action_file}" ]] || /bin/rm -f "${action_file}"
	[[ ! -f "${state_file}" ]] || /bin/rm -f "${state_file}"
	/usr/bin/defaults write "${preference_domain}" installed -bool false
	/usr/bin/killall SystemUIServer 2>/dev/null || true
	echo uninstalled
	;;
status)
	/usr/bin/osascript "${source_root}/Sources/folder-settings.applescript" status "${screenshot_dir}"
	;;
*) echo "Usage: manage.zsh {install|uninstall|status} [zh|en]" >&2; exit 2 ;;
esac
