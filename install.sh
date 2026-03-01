#!/data/data/com.termux/files/usr/bin/bash
set -e

echo "======================================"
echo "  YUGIOH POC INSTALLER (Termux)"
echo "======================================"

# -------- CONFIG --------
ZIP_PASS="gamiq"
ZIP_URL="https://drive.google.com/uc?export=download&id=1fcFXZllDk4gS-NmuTpIi4OXcT_NONjc7"
WORK_DIR="$HOME/install_tmp"
DOWNLOAD_DIR="$HOME/storage/downloads"
GAME_DIR="$DOWNLOAD_DIR/YUGIOHPOC"
# ------------------------

echo ""
echo "[1/6] Preparing environment..."

pkg update -y
pkg install -y curl unzip

echo ""
echo "[2/6] Requesting storage permission..."
termux-setup-storage

mkdir -p "$WORK_DIR"
cd "$WORK_DIR"

echo ""
echo "[3/6] Downloading install.zip..."
curl -L --progress-bar "$ZIP_URL" -o install.zip

echo ""
echo "[4/6] Extracting install.zip..."
rm -rf install
unzip -P "$ZIP_PASS" install.zip > /dev/null

echo ""
echo "[5/6] Extracting dmg.zip → $GAME_DIR"
mkdir -p "$GAME_DIR"
unzip -o -P "$ZIP_PASS" dmg.zip -d "$GAME_DIR" > /dev/null

echo ""
echo "[6/6] Opening APK installer..."
mv winlator.apk "$DOWNLOAD_DIR/"
termux-open "$DOWNLOAD_DIR/winlator.apk"

echo ""
echo "======================================"
echo " DONE!"
echo "Press INSTALL when Android installer opens."
echo "Game data installed at: $GAME_DIR"
echo "======================================"