#!/bin/zsh
set -euo pipefail
cd "${0:A:h:h}"
/bin/zsh -n build.sh package.sh notarize.sh Scripts/manage.zsh
/usr/bin/plutil -lint Info.plist SnapKeep.entitlements
readonly check_dir="$(/usr/bin/mktemp -d "${TMPDIR:-/tmp/}snapkeep-check.XXXXXX")"
for script_file in Sources/*.applescript Tools/*.applescript; do
	/usr/bin/osacompile -o "${check_dir}/${script_file:t:r}.scpt" "${script_file}"
done
echo 'Shell, plist, and AppleScript checks passed.'
