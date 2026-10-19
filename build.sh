#!/bin/zsh
set -euo pipefail
cd "${0:A:h}"
readonly app_path="${PWD}/build/SnapKeep.app"
/bin/mkdir -p "${app_path}/Contents/MacOS" "${app_path}/Contents/Resources/Sources" "${app_path}/Contents/Resources/Scripts" build/modules
for architecture_name in arm64 x86_64; do
	/usr/bin/xcrun swiftc -O -target "${architecture_name}-apple-macos12.0" -module-cache-path "${PWD}/build/modules" Sources/SnapKeep.swift -o "build/SnapKeep-${architecture_name}" -framework AppKit
done
/usr/bin/lipo -create build/SnapKeep-arm64 build/SnapKeep-x86_64 -output "${app_path}/Contents/MacOS/SnapKeep"
/bin/cp Info.plist "${app_path}/Contents/Info.plist"
/bin/cp Sources/*.applescript "${app_path}/Contents/Resources/Sources/"
/bin/cp Scripts/manage.zsh "${app_path}/Contents/Resources/Scripts/"
/bin/cp Assets/AppIcon.icns "${app_path}/Contents/Resources/"
/bin/chmod 755 "${app_path}/Contents/MacOS/SnapKeep" "${app_path}/Contents/Resources/Scripts/manage.zsh"
if [[ -n "${SIGNING_IDENTITY:-}" ]]; then
	/usr/bin/codesign --force --options runtime --timestamp --entitlements SnapKeep.entitlements --sign "${SIGNING_IDENTITY}" "${app_path}"
else
	/usr/bin/codesign --force --sign - "${app_path}"
fi
/usr/bin/codesign --verify --deep --strict "${app_path}"
/usr/bin/lipo -archs "${app_path}/Contents/MacOS/SnapKeep"
echo "Built ${app_path}"
