# SnapKeep 1.0.0 / 截屏即贴 1.0.0

![SnapKeep: screenshot once, save and copy](https://raw.githubusercontent.com/TonT-wilshere/macos-screenshot-clipboard/main/Assets/demo.gif)

[中文](#中文) · [English](#english) · [Agent Skill / 技能说明](https://github.com/TonT-wilshere/macos-screenshot-clipboard/tree/main/skills/macos-screenshot-save-copy)

**macOS screenshot automation + an installable Agent Skill / Mac 截屏自动保存与复制，附可安装 Agent Skill。**

```bash
npx skills add TonT-wilshere/macos-screenshot-clipboard --skill macos-screenshot-save-copy -g
```

The skill guides agents through setup; the app performs the local automation. / Skill 提供代理操作说明，应用负责实际的本机自动化。

## 中文

**截一次，保存和复制一起完成。** 不用先找文件再复制，也不用改掉熟悉的 Mac 截屏快捷键。

- `⌘⇧3 / ⌘⇧4 / ⌘⇧5` 照旧；文件自动存入桌面“截屏”，图片自动进入剪贴板。
- 复制成功后轻提示“已复制到剪贴板”，不弹出查看器询问。
- 中英文原生界面，一键启用、更新或卸载。
- Apple Silicon + Intel 通用版，最低 macOS 12；当前功能在 macOS 15 验证。
- 完全本机运行，无账户、无上传、无遥测。
- 卸载保留全部图片，恢复安装前的保存设置；尊重后来手动更改的位置。

**下载 DMG（推荐）或 ZIP → 打开 SnapKeep.app → 点击启用 → 允许 System Events。** 配置后可退出应用。

当前发行未经 Apple 公证。首次打开若被拦截，请按 [Apple 官方指引](https://support.apple.com/zh-cn/102445)在“隐私与安全性”中选择“仍要打开”。通知可能受专注模式影响；复制在文件实际保存后发生。

如果它省下了你的一步，欢迎 [Star 这个项目](https://github.com/TonT-wilshere/macos-screenshot-clipboard)。⭐

## English

**One screenshot. Saved and copied.** Keep your usual shortcuts and get both the file and the clipboard image.

- Use `⌘⇧3 / ⌘⇧4 / ⌘⇧5` as usual; screenshots go to `Desktop/截屏` and the clipboard.
- A quiet “Copied to clipboard” notification, without a viewer prompt.
- Native Chinese / English setup, update, and uninstall controls.
- Universal Apple Silicon + Intel build targeting macOS 12+; behavior verified on macOS 15.
- Local-only processing: no account, upload, or telemetry.
- Uninstall keeps images and restores previous settings while respecting later destination changes.

**Download DMG (recommended) or ZIP → open SnapKeep.app → click Enable → allow System Events.** Quit the setup app afterward if you like.

This release is not Apple-notarized. If blocked, follow [Apple's Open Anyway instructions](https://support.apple.com/en-us/102445). Notifications may be suppressed by Focus; copying starts after the file is saved.

If it saves you a step, please [Star the project](https://github.com/TonT-wilshere/macos-screenshot-clipboard). ⭐

## Files / 下载文件

- `SnapKeep-1.0.0-macOS-Universal.dmg` — recommended installer / 推荐
- `SnapKeep-1.0.0-macOS-Universal.zip` — app archive / 应用压缩包
- `SHA256SUMS.txt` — artifact checksums / 校验值
