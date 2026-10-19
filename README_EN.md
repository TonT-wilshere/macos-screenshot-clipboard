<div align="center">

<img src="Assets/demo.gif" alt="SnapKeep illustrated workflow: take a Mac screenshot, save the file, copy the image, and paste" width="960">

# SnapKeep

**One screenshot. Saved and copied.**

Keep your usual Mac screenshot shortcuts. Get the file and the clipboard image together.

[中文](README.md) · **[Download for macOS](https://github.com/TonT-wilshere/macos-screenshot-clipboard/releases/latest)** · [Report an issue](https://github.com/TonT-wilshere/macos-screenshot-clipboard/issues)

![macOS](https://img.shields.io/badge/macOS-12%2B-111827?logo=apple)
![Universal](https://img.shields.io/badge/Apple_Silicon_%2B_Intel-Universal-2563eb)
![License](https://img.shields.io/badge/License-MIT-16a34a)
![Local only](https://img.shields.io/badge/Privacy-local_only-0f766e)
[![Build](https://github.com/TonT-wilshere/macos-screenshot-clipboard/actions/workflows/ci.yml/badge.svg)](https://github.com/TonT-wilshere/macos-screenshot-clipboard/actions/workflows/ci.yml)
[![Release](https://img.shields.io/github/v/release/TonT-wilshere/macos-screenshot-clipboard)](https://github.com/TonT-wilshere/macos-screenshot-clipboard/releases/latest)
[![Downloads](https://img.shields.io/github/downloads/TonT-wilshere/macos-screenshot-clipboard/total)](https://github.com/TonT-wilshere/macos-screenshot-clipboard/releases)
[![Stars](https://img.shields.io/github/stars/TonT-wilshere/macos-screenshot-clipboard?style=social)](https://github.com/TonT-wilshere/macos-screenshot-clipboard/stargazers)

</div>

## Take a screenshot. Then copy it again?

You want to keep a screenshot for later and paste it into a chat, note, bug report, or AI conversation right now. macOS normally saves the file; adding Control copies it instead of saving it.

SnapKeep connects the steps: **capture → save → copy the image → paste**. No new shortcut to memorize.

## Features

- Saves screenshots to `Desktop/截屏` and copies the image itself to the clipboard.
- Shows a “Copied to clipboard” notification without opening an image viewer or a modal prompt.
- Keeps `⌘⇧3`, `⌘⇧4`, and `⌘⇧5` working as usual.
- Native Chinese / English setup UI with a remembered language choice.
- Universal app for Apple Silicon and Intel, targeting macOS 12+.
- Quit the setup app after enabling; macOS Folder Actions keeps processing new images.
- Local-only processing. No account, upload, telemetry, or administrator password.
- Uninstall removes its rule, restores the previous save settings, and keeps all screenshots.

Useful for messaging, notes, documentation, bug reports, and visual context for AI assistants. Pasting depends on the destination app accepting images.

## Download & install

1. Download **`SnapKeep-1.0.0-macOS-Universal.dmg`** or ZIP from [Releases](https://github.com/TonT-wilshere/macos-screenshot-clipboard/releases/latest).
2. Drag `SnapKeep.app` to Applications and open it.
3. Click **Enable / Update SnapKeep**. Allow **System Events** control when macOS asks.
4. Take a screenshot with `⌘⇧4`, wait for the file to save, then paste with `⌘V`.

The app targets macOS 12 and newer. Local behavior has been verified on macOS 15; feedback on other versions is welcome.

<img src="Assets/setup-en.png" alt="SnapKeep English setup" width="420"> <img src="Assets/setup-zh.png" alt="SnapKeep Chinese setup" width="420">

**This independent open-source release is not Apple-notarized.** If macOS blocks the first launch, follow [Apple's Open Anyway instructions](https://support.apple.com/en-us/102445) in System Settings → Privacy & Security. Do not disable Gatekeeper or System Integrity Protection.

You can quit SnapKeep after setup. Reopen it to update, change the notification language, or uninstall. The top-right language switch follows the system language on first launch and remembers your selection.

## Behavior to know

- Copying starts **after the screenshot file is saved**. The macOS floating thumbnail can delay this by several seconds; its setting is available under `⌘⇧5 → Options`.
- Adding Control uses macOS's copy-only shortcut and does not save a file.
- New PNG, JPEG, HEIC/HEIF, and TIFF images in `Desktop/截屏` trigger copying, including images manually added to that folder. Screen recordings are ignored.
- If several images arrive together, the clipboard keeps the last successfully processed image. This is not a clipboard-history manager.
- Setup briefly refreshes the global Folder Actions switch to load the new script; other folder rules are retained.
- If you later change the screenshot save destination, the tool does not follow that new folder. Uninstall also respects your newly chosen destination.
- Notification visibility depends on macOS settings and Focus mode. A suppressed notification does not prevent copying.

## Troubleshooting

If copying stops, confirm the file is in `Desktop/截屏`, then click Enable / Update again. If automation access was denied, allow SnapKeep to control System Events under System Settings → Privacy & Security → Automation. Check the enabled rule in Apple's Folder Actions Setup if needed.

An unwanted “new items” dialog is usually Apple's `add - new item alert.scpt` sample. Setup detaches that sample from this screenshot folder and migrates the early Chinese-named copy script.

## Build from source

Requires macOS and Xcode Command Line Tools. No third-party dependency is needed for the app or normal builds. Python/Pillow is only for regenerating marketing artwork.

```bash
git clone https://github.com/TonT-wilshere/macos-screenshot-clipboard.git
cd macos-screenshot-clipboard
./Scripts/check.zsh
./build.sh
open build/SnapKeep.app
```

`./package.sh` creates Universal DMG/ZIP packages and SHA-256 checksums. CI validates AppleScript compilation, code-signature structure, and both `arm64` / `x86_64` slices. See [NOTARIZATION.md](NOTARIZATION.md) for signing and notarization.

## Agent Skill

[macos-screenshot-save-copy](skills/macos-screenshot-save-copy/SKILL.md) helps compatible agents handle “save and copy a Mac screenshot” requests, including setup, permissions, verification, and uninstall. It can be used by compatible Codex, Claude Code, and other Agent Skills clients.

```bash
npx skills add TonT-wilshere/macos-screenshot-clipboard --skill macos-screenshot-save-copy -g
```

Manual installation of the skill folder is also possible using your client's instructions. [llms.txt](llms.txt) provides a concise project summary for retrieval tools.

## Privacy & implementation

A native Swift/AppKit interface configures an AppleScript Folder Action. When a new image arrives, AppKit writes image data to the system clipboard and posts a notification. There is no network service, privileged helper, or extra LaunchAgent. The macOS dispatcher runs the rule after the setup app quits.

The project uploads no screenshots or clipboard contents. Other macOS features and clipboard apps still apply; for example, Universal Clipboard can sync clipboard contents if you enabled it. See [SECURITY.md](SECURITY.md).

## Support

[Issues](https://github.com/TonT-wilshere/macos-screenshot-clipboard/issues) · [Contributing](CONTRIBUTING.md) · [MIT License](LICENSE)

If SnapKeep saves you a step, leave a **Star** so more Mac users can find it. Sharing the download link with someone who screenshots the same way helps too. ⭐
