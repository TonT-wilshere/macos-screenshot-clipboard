# Security & privacy / 安全与隐私

SnapKeep processes new images inside `~/Desktop/截屏` using Apple's Folder Actions and AppKit. It does not capture the screen itself, read unrelated image folders, send network requests, store clipboard history, or request administrator privileges.

Configuration requires user-authorized System Events automation. The installed script is `~/Library/Scripts/Folder Action Scripts/SnapKeep - Screenshot to Clipboard.scpt`. A small preference snapshot in `~/Library/Application Support/SnapKeep/state.plist` lets uninstall restore the previous screenshot destination when it is still managed by SnapKeep. The current language and setup flag are in the `io.github.tont-wilshere.snapkeep` preferences domain.

Clipboard contents are exposed according to the normal macOS clipboard model. Other apps, Universal Clipboard, clipboard managers, and user-enabled sync can affect that model. SnapKeep does not control those features. Each newly added image replaces the current clipboard contents.

The release is ad-hoc signed for structural integrity, **not Developer ID signed or Apple-notarized**. SHA-256 values identify release artifacts; they are not a substitute for notarization. Source code and reproducible packaging scripts are included. No system security protection should be disabled for installation.

Report a vulnerability through GitHub's private vulnerability reporting feature when available. Otherwise open an issue describing the affected component without private images, credentials, or exploit-sensitive details.

中文：本工具只处理截屏文件夹中的新增图片，不联网、不保存剪贴板历史。每张新图会覆盖当前剪贴板；系统通用剪贴板和其他剪贴板应用仍可能读取或同步它。权限由 macOS 管理；卸载保留所有图片并尽可能恢复先前设置。当前发布未经过 Apple 公证。
