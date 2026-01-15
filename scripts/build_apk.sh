#!/bin/bash

# AI Offline App Build Script

echo "==================================="
echo "AI Offline - Build Optimization"
echo "==================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo -e "${RED}Flutter SDK not found!${NC}"
    exit 1
fi

echo -e "${YELLOW}Cleaning build files...${NC}"
flutter clean

echo -e "${YELLOW}Getting dependencies...${NC}"
flutter pub get

# Build for Android
echo -e "${YELLOW}Building Android APK (Release)...${NC}"
flutter build apk --release --split-per-abi

if [ $? -eq 0 ]; then
    echo -e "${GREEN}Android build successful!${NC}"
    ls -lh build/app/outputs/flutter-apk/
else
    echo -e "${RED}Android build failed!${NC}"
    exit 1
fi

# Optional: Build App Bundle for Play Store
echo -e "${YELLOW}Building Android App Bundle...${NC}"
flutter build appbundle --release

if [ $? -eq 0 ]; then
    echo -e "${GREEN}App Bundle build successful!${NC}"
    ls -lh build/app/outputs/bundle/release/
else
    echo -e "${RED}App Bundle build failed!${NC}"
fi

echo -e "${GREEN}==================================="
echo "Build complete!"
echo "===================================${NC}"
