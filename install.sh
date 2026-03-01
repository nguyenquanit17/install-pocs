#!/data/data/com.termux/files/usr/bin/bash
set -e

echo "======================================"
echo "  YUGIOH POC INSTALLER v2 (Termux)"
echo "======================================"

# -------- CONFIG --------
ZIP_PASS="gamiq"
FILEID="1fcFXZllDk4gS-NmuTpIi4OXcT_NONjc7"
FILENAME="install.zip"
WORK_DIR="$HOME/install_tmp"
DOWNLOAD_DIR="$HOME/storage/downloads"
GAME_DIR="$DOWNLOAD_DIR/YUGIOHPOC"
# ------------------------

# -------- Step 1: Prepare environment --------
echo "[1/7] Installing required packages..."
pkg update -y
pkg install -y curl unzip

# -------- Step 2: Storage check --------
if [ ! -d "$HOME/storage" ]; then
    echo "[2/7] Storage permission not found. Requesting..."
    termux-setup-storage
    echo "Please grant storage permission, then rerun the script."
    exit 0
else
    echo "[2/7] Storage permission already granted."
fi

mkdir -p "$WORK_DIR"
cd "$WORK_DIR"

# -------- Step 3: Download install.zip from Google Drive --------
echo "[3/7] Downloading install.zip from Google Drive..."

curl -c /tmp/cookies.txt "https://drive.google.com/uc?export=download&id=${FILEID}" -o /tmp/intermediate.html

CONFIRM=$(grep -o 'confirm=[^&]*' /tmp/intermediate.html | head -n1 | cut -d= -f2 || echo "")

if [ -n "$CONFIRM" ]; then
    curl -L -b /tmp/cookies.txt "https://drive.google.com/uc?export=download&confirm=${CONFIRM}&id=${FILEID}" -o "$FILENAME"
else
    curl -L -b /tmp/cookies.txt "https://drive.google.com/uc?export=download&id=${FILEID}" -o "$FILENAME"
fi

rm -f /tmp/cookies.txt /tmp/intermediate.html

# -------- Step 4: Extract install.zip --------
echo "[4/7] Extracting install.zip..."
rm -rf install
unzip -P "$ZIP_PASS" "$FILENAME" > /dev/null

# -------- Step 5: Extract dmg.zip --------
echo "[5/7] Extracting dmg.zip → $GAME_DIR"
mkdir -p "$GAME_DIR"
unzip -o -P "$ZIP_PASS" dmg.zip -d "$GAME_DIR" > /dev/null

# -------- Step 6: Open APK installer --------
echo "[6/7] Opening APK installer..."
mv winlator.apk "$DOWNLOAD_DIR/"
termux-open "$DOWNLOAD_DIR/winlator.apk"

# -------- Step 7: Done --------
echo "[7/7] Installation process complete!"
echo "Please press INSTALL when Android installer opens."
echo "Game data installed at: $GAME_DIR"
echo "======================================"