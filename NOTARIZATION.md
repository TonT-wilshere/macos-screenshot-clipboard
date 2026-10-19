# Signing & notarization / 签名与公证

The current public release is ad-hoc signed and **not notarized**. A valid Developer ID Application identity and a notarytool keychain profile are required to notarize it. A free self-signed identity is not equivalent.

With an existing identity and profile, maintainers can run:

```bash
SIGNING_IDENTITY='Developer ID Application: YOUR NAME (TEAMID)' \
NOTARY_PROFILE='your-existing-keychain-profile' ./notarize.sh
```

The script signs with Hardened Runtime, submits the app, requires `Accepted`, staples and validates its ticket, packages without rebuilding, then submits/staples the DMG and regenerates checksums. Logs remain in ignored `release/` files. A normal `./build.sh` or `./package.sh` still produces an ad-hoc build. The authenticated notarization path has not been executed in this repository because no valid identity is available.

Do not commit certificates, private keys, account passwords, keychain contents, or notarization credentials. Do not claim a release is notarized until the actual artifacts have been accepted and verified.

中文：当前构建未公证。只有持有效 Developer ID Application 证书及已配置公证凭据的维护者可以执行上述流程。该脚本已做语法检查，尚未进行真实 Apple 提交。公证成功并验证最终安装包前，不得修改发行页的未公证说明。

Apple references: [Notarizing macOS software](https://developer.apple.com/documentation/security/notarizing-macos-software-before-distribution), [Opening apps safely](https://support.apple.com/en-us/102445).
