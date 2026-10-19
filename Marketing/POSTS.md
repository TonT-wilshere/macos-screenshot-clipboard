# 发布文案 / Launch copy

Prepared copy for the maintainer. Nothing in this file means it has been posted to a community. Attach `Assets/demo.gif` and link the release; adapt to each community's current rules.

## 中文：小红书 / 抖音配文

标题：Mac 截完图，终于不用再找文件复制了

我截屏有个很固定的习惯：想把图片留着，又想马上发给别人。

但 Mac 默认要么保存文件，要么按住 Control 只复制。有时候一天要截十几张，就总在“打开文件夹—找刚才那张—再复制”之间来回。

所以做了个很小的工具，叫「截屏即贴」。快捷键还是原来的 ⌘⇧3 / ⌘⇧4，截完自动收进桌面“截屏”文件夹，也自动复制好。想发给朋友、贴进笔记或者让 AI 看界面，直接 ⌘V 就行。

它不弹照片查看器，不用注册，图片在自己电脑上处理。装好后连设置窗口都可以关掉。

已经免费开源，M 芯片和 Intel Mac 都有通用安装包。需要的话搜 GitHub：TonT-wilshere / macos-screenshot-clipboard。觉得顺手，点个 Star 就当给这个小工具加个油。

#Mac技巧 #效率工具 #开源项目 #截图 #macOS

## 中文：V2EX / 开发者社区

标题：[开源自荐] 做了个 Mac 截屏小工具：保留文件的同时自动复制，原快捷键照用

平时做问题反馈、写文档或者把界面贴给 AI，我经常同时需要截图文件和剪贴板图片。macOS 加 Control 是只复制不保存，普通截屏又要再找文件复制。

SnapKeep 用系统自带 Folder Actions 把两步接起来：截图进桌面“截屏”目录后，用 AppKit 写入剪贴板，再发一个成功通知。安装界面是 Swift/AppKit，有中英文切换。配置后可以退出设置应用，规则继续由系统运行。

首版提供 Apple Silicon + Intel Universal DMG/ZIP、可恢复设置的卸载、源码和 Agent Skill。当前构建没有 Apple 公证，首次打开可能需要在隐私设置中手动放行，这点在下载页有写清楚。

仓库：https://github.com/TonT-wilshere/macos-screenshot-clipboard
下载：https://github.com/TonT-wilshere/macos-screenshot-clipboard/releases/latest

有相同截图习惯的朋友可以试试，也欢迎报兼容性问题。方便的话给个 Star，能让更多人找到它。

## English: macOS / open-source communities

Title: I made a tiny Mac tool that saves screenshots AND copies them, using the same shortcuts

I often want to keep a screenshot and immediately paste it into a chat, note, or bug report. On macOS, the Control shortcut copies instead of saving; normal screenshots need another step before I can paste them.

SnapKeep connects those two actions. Use the screenshot shortcut you already know. The file goes into a desktop folder, the image goes onto the clipboard, and a short notification confirms it. The setup app can quit afterward—macOS Folder Actions handles new files.

It's free and MIT-licensed, with a native Chinese/English setup UI, Apple Silicon + Intel packages, and an uninstall option that keeps your screenshots. No account or network upload. This first release isn't Apple-notarized, so the download page explains the first-launch step.

Code and illustrated demo: https://github.com/TonT-wilshere/macos-screenshot-clipboard
Download: https://github.com/TonT-wilshere/macos-screenshot-clipboard/releases/latest

Feedback from people who screenshot this way would be useful. If it saves you a step, a Star helps other Mac users find it.

## Hacker News draft

Title: Show HN: SnapKeep – Save Mac screenshots and copy them with the usual shortcuts

URL: https://github.com/TonT-wilshere/macos-screenshot-clipboard

First comment: I built this for the small gap between macOS's save-only and copy-only screenshot shortcuts. A native setup app attaches an AppleScript Folder Action to a desktop screenshots folder; AppKit copies the new image after saving. The project includes inspectable source, Universal builds, uninstall/restore, and an illustrated demo. No service or account. The first release is ad-hoc signed, not notarized. I'd appreciate feedback on macOS version compatibility and the install flow.
