#!/data/data/com.termux/files/usr/bin/bash

set -e

echo "======================================"
echo " YUGIOH POC INSTALLER (Termux)"
echo "======================================"

# -------- CONFIG --------
ZIP_PASS="gamiq"
ZIP_URL="https://drive.google.com/uc?export=download&id=1fcFXZllDk4gS-NmuTpIi4OXcT_NONjc7"
WORK_DIR="$HOME/install_tmp"
DOWNLOAD_DIR="$HOME/storage/downloads"
GAME_DIR="$DOWNLOAD_DIR/YUGIOHPOC"
# ------------------------

echo ""
echo "Preparing environment..."

pkg update -y
pkg install -y curl unzip

echo ""
echo "Requesting storage permission..."
termux-setup-storage

mkdir -p "$WORK_DIR"
cd "$WORK_DIR"

echo ""
echo "Downloading install.zip..."

curl -L "$ZIP_URL" -o install.zip

echo ""
echo "Extracting install.zip..."

unzip -P "$ZIP_PASS" install.zip

echo ""
echo "Preparing game directory..."

mkdir -p "$GAME_DIR"

echo ""
echo "Extracting dmg.zip → $GAME_DIR"

unzip -o -P "$ZIP_PASS" dmg.zip -d "$GAME_DIR"

echo ""
echo "Moving APK..."

mv winlator.apk "$DOWNLOAD_DIR/"

echo ""
echo "Opening APK installer..."

termux-open "$DOWNLOAD_DIR/winlator.apk"

echo ""
echo "======================================"
echo " DONE!"
echo ""
echo "Next step:"
echo "Press INSTALL when Android installer opens."
echo "======================================"