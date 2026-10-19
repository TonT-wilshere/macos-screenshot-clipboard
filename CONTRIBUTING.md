# Contributing / 参与贡献

Issues and small pull requests are welcome. Include the macOS version, CPU architecture, screenshot shortcut, whether the file reaches `Desktop/截屏`, and whether pasting works. Use a synthetic test image instead of sharing your real screen or clipboard contents.

Run `./Scripts/check.zsh` and `./build.sh` before submitting code changes. For packaging changes, run `./package.sh` and verify both architectures and `codesign --verify --deep --strict` on an extracted ZIP. Functional checks should use a disposable folder action and a synthetic image; restore the user's clipboard afterward.

The public app has no third-party runtime dependency. Keep the original screenshot shortcuts, localized setup, non-modal success notification, and uninstall retention behavior. Do not change unrelated folder actions or replace a user's later screenshot destination during uninstall.

Marketing assets are generated with `python3 Tools/make_assets.py` (Pillow needed). The animation is an illustrated workflow and must stay labelled as such; do not present it as a recording or include private screenshots.

中文：欢迎反馈和提交 PR。请提供系统版本、芯片架构及文件保存/粘贴是否正常，用示意图片复现，不要上传私人截屏。普通构建无需第三方依赖；GIF 素材生成需要 Pillow。
