# Agent Skill catalog / 技能目录

SnapKeep provides one installable Agent Skill for **macOS screenshot and clipboard automation**.

| Skill | What it helps an agent do / 能力 |
| --- | --- |
| [macos-screenshot-save-copy](macos-screenshot-save-copy/SKILL.md) | Set up, verify, troubleshoot, and uninstall automatic screenshot saving and image copying. / 配置、验证、排查和卸载 Mac 截屏自动保存与复制。 |

## Install / 安装

```bash
npx skills add TonT-wilshere/macos-screenshot-clipboard --skill macos-screenshot-save-copy -g
```

The skill is agent context, not the running screenshot service. Follow its instructions to configure SnapKeep on macOS. / Skill 是代理操作说明；自动截屏复制仍需按指引配置 SnapKeep。

## Discover from this repository / 验证仓库识别

```bash
npx skills add TonT-wilshere/macos-screenshot-clipboard --list
```

Canonical skill path: `skills/macos-screenshot-save-copy/SKILL.md`.

Common user intents: save and copy Mac screenshots, screenshot to clipboard, automatically copy screenshots, desktop screenshot organization; Mac 截屏同时保存和复制、截图自动复制剪贴板、截屏自动归档。

The repository follows the [`skills` CLI discovery layout](https://github.com/vercel-labs/skills#skill-discovery). The command above resolves this repository directly; `skills find` / skills.sh use a separate global directory. [Official publishing and discovery guide](https://vercel.com/kb/guide/agent-skills-creating-installing-and-sharing-reusable-agent-context#5-publishing-and-discoverability-how-listing-actually-works).

[中文 / English overview](../README.md) · [Full English README](../README_EN.md) · [Retrieval summary](../llms.txt)
