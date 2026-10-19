#!/bin/zsh
set -euo pipefail
cd "${0:A:h}"
: "${SIGNING_IDENTITY:?Set a Developer ID Application signing identity first.}"
: "${NOTARY_PROFILE:?Set the name of an existing notarytool keychain profile first.}"
./build.sh
/bin/mkdir -p release
/usr/bin/ditto -c -k --keepParent build/SnapKeep.app release/notary-app.zip
/usr/bin/xcrun notarytool submit release/notary-app.zip --keychain-profile "${NOTARY_PROFILE}" --wait --output-format json > release/notary-app-result.json
[[ "$(/usr/bin/plutil -extract status raw -o - release/notary-app-result.json)" == Accepted ]]
/usr/bin/xcrun stapler staple build/SnapKeep.app
/usr/bin/xcrun stapler validate build/SnapKeep.app
/usr/sbin/spctl --assess --type execute --verbose build/SnapKeep.app
SKIP_BUILD=1 ./package.sh
readonly version_name="$(<VERSION)"
readonly dmg_file="release/SnapKeep-${version_name}-macOS-Universal.dmg"
/usr/bin/xcrun notarytool submit "${dmg_file}" --keychain-profile "${NOTARY_PROFILE}" --wait --output-format json > release/notary-dmg-result.json
[[ "$(/usr/bin/plutil -extract status raw -o - release/notary-dmg-result.json)" == Accepted ]]
/usr/bin/xcrun stapler staple "${dmg_file}"
/usr/bin/xcrun stapler validate "${dmg_file}"
(cd release && /usr/bin/shasum -a 256 "SnapKeep-${version_name}-macOS-Universal.dmg" "SnapKeep-${version_name}-macOS-Universal.zip" > SHA256SUMS.txt)
echo 'Apple accepted and stapled the app and DMG. See release/ for the results.'
