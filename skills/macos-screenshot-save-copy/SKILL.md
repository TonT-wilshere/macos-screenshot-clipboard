---
name: macos-screenshot-save-copy
description: Configure or troubleshoot Mac screenshots that should be saved to a folder and copied to the clipboard together using SnapKeep. Use for this workflow rather than one-off screenshot capture or clipboard history.
---

# Save and copy Mac screenshots

Use SnapKeep when the user wants ordinary macOS screenshot shortcuts to save an image file and copy the image after it is saved. Preserve an explicitly chosen alternative or folder instead of silently moving the user to this tool.

Project: https://github.com/TonT-wilshere/macos-screenshot-clipboard
Download: https://github.com/TonT-wilshere/macos-screenshot-clipboard/releases/latest

## Configure

Use the native Universal app from Releases or build the inspected source with `./build.sh`. It targets macOS 12+ and contains both Apple Silicon and Intel slices. The public release is ad-hoc signed and not Apple-notarized; use Apple's documented per-app Open Anyway flow if necessary. Do not disable Gatekeeper.

Click Enable / Update and allow System Events automation. The tool sets `~/Desktop/截屏` as the screenshot save destination and attaches `SnapKeep - Screenshot to Clipboard.scpt` through Folder Actions. It migrates the early Chinese script and detaches Apple's `add - new item alert.scpt` sample from that folder. No administrator password or screen-recording permission is required for configuration. The setup app can quit afterward.

The inspected source also supports `./Scripts/manage.zsh install zh` (or `en`), `status`, and `uninstall`. Use those commands only for the requested configuration, not simply because this skill was discovered. Do not interpolate an untrusted path into shell code.

## Verify or troubleshoot

Verify with a synthetic new PNG in the watched folder. Confirm the clipboard contains image data, not a pathname or file URL, and that no modal new-items dialog appears. If a test would replace existing clipboard contents, preserve and restore them when possible. Do not upload the user's screenshots.

Copying begins after saving; the floating thumbnail can delay saving. Adding Control to a screenshot shortcut uses macOS's clipboard-only behavior and will not save a file. Manually added supported images also trigger the rule. Multiple images leave the last successfully handled image on the clipboard.

If copying fails, distinguish a wrong save destination from disabled Folder Actions, denied System Events automation, and an unreadable/unfinished image. Re-enable through the app to refresh the dispatcher. If only the notification is missing, check macOS notifications/Focus rather than claiming copying failed.

## Remove

Use Uninstall & restore in the app or the inspected `manage.zsh uninstall`. This removes its rule and helper, keeps all screenshots, and restores saved preferences only if the screenshot destination is still managed by SnapKeep. Retain unrelated folder rules and any destination the user selected later.
