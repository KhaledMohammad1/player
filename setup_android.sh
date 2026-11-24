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

# Build separate ARM packages (32-bit is included for compatible Redmi A3 firmware).
flutter build apk --release --split-per-abi
