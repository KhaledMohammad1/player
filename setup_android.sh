#!/usr/bin/env bash
set -euo pipefail

# Run from the repository root. Requires Flutter stable and Android SDK.
APP_DIR="app"

flutter create --platforms=android --project-name player --org com.yalkhodary "$APP_DIR"
mkdir -p "$APP_DIR/lib"
cp -R lib/. "$APP_DIR/lib/"

cd "$APP_DIR"
flutter pub add flutter_riverpod media_kit media_kit_video media_kit_libs_android_video path_provider path file_picker:^10.0.0 audio_service audio_session liquid_design:^0.4.1 audio_metadata_reader video_thumbnail
flutter pub get

# video_thumbnail 0.5.6 still calls the removed jcenter() repository.
PLUGIN_GRADLE="$(find "$HOME/.pub-cache/hosted/pub.dev" -path '*/video_thumbnail-*/android/build.gradle' -print -quit)"
if [ -n "$PLUGIN_GRADLE" ]; then
  sed -i 's/jcenter()/google(); mavenCentral()/g' "$PLUGIN_GRADLE"
fi

# Build separate ARM packages (32-bit is included for compatible Redmi A3 firmware).
flutter build apk --release --split-per-abi
