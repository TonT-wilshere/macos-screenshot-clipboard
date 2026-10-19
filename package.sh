#!/bin/zsh
set -euo pipefail
cd "${0:A:h}"
[[ "${SKIP_BUILD:-0}" == 1 ]] || ./build.sh
readonly version_name="$(<VERSION)"
readonly artifact_name="SnapKeep-${version_name}-macOS-Universal"
/bin/mkdir -p release
readonly staging_dir="$(/usr/bin/mktemp -d "${TMPDIR:-/tmp/}snapkeep-dmg.XXXXXX")"
/usr/bin/ditto build/SnapKeep.app "${staging_dir}/SnapKeep.app"
/bin/ln -s /Applications "${staging_dir}/Applications"
/bin/cp Packaging/Read-Me-First.txt "${staging_dir}/Read-Me-First.txt"
/usr/bin/ditto -c -k --sequesterRsrc --keepParent build/SnapKeep.app "release/${artifact_name}.zip"
/usr/bin/hdiutil create -volname 'SnapKeep' -srcfolder "${staging_dir}" -format UDZO -ov "release/${artifact_name}.dmg"
(cd release && /usr/bin/shasum -a 256 "${artifact_name}.dmg" "${artifact_name}.zip" > SHA256SUMS.txt)
/usr/bin/hdiutil verify "release/${artifact_name}.dmg"
echo "Release files are in ${PWD}/release"
