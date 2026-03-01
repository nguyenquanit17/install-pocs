#!/data/data/com.termux/files/usr/bin/bash
set -e

echo "======================================"
echo "  YUGIOH POC INSTALLER v5 (Termux)"
echo "======================================"

# -------- INPUT --------
if [ -z "$1" ]; then
    echo "Usage:"
    echo "curl -L https://yourhost.com/install.sh | bash -s \"GOOGLE_DRIVE_FILE_ID\""
    exit 1
fi

IFS='|' read -ra FILE_IDS <<< "$1"
ZIP_ID="${FILE_IDS[0]}"

# -------- CONFIG --------
ZIP_PASS="gamiQ"
ZIP_LINK="https://drive.google.com/uc?id=$ZIP_ID"
WORK_DIR="$HOME/install_tmp"
TARGET_DIR="$HOME/storage/downloads/GamiQ"
GAME_DIR="$TARGET_DIR/YUGIOHPOC"
# ------------------------

# -------- Step 1: Install dependencies --------
echo "🔧 Cài Python + unzip..."
pkg update -y
pkg install -y python unzip

echo "📦 Cài gdown..."
pip install --no-cache-dir gdown

# -------- Step 2: Storage permission --------
if [ ! -d "$HOME/storage" ]; then
    echo "📂 Storage permission chưa cấp. Yêu cầu cấp..."
    termux-setup-storage
    echo "⚠️ Vui lòng rerun script sau khi cấp quyền storage."
    exit 0
else
    echo "📂 Storage permission đã được cấp."
fi

# -------- Step 3: Prepare directories --------
mkdir -p "$WORK_DIR"
mkdir -p "$TARGET_DIR"
mkdir -p "$GAME_DIR"
cd "$WORK_DIR"

echo "📁 Thư mục download: $TARGET_DIR"

# -------- Step 4: Download install.zip --------
echo "🔽 Tải install.zip từ Google Drive..."
gdown "$ZIP_LINK" -O "$TARGET_DIR/install.zip"

# -------- Step 5: Extract install.zip --------
echo "📂 Giải nén install.zip..."
unzip -o -P "$ZIP_PASS" "$TARGET_DIR/install.zip" -d "$TARGET_DIR/install"

# -------- Step 6: Extract game data --------
echo "📂 Giải nén Yugioh data..."
unzip -o -P "$ZIP_PASS" \
"$TARGET_DIR/install/Yugioh! Power of Chaos - 3 in 1 Winlator - Pass gamiQ.zip" \
-d "$GAME_DIR"

# -------- Step 7: Open APK installer --------
echo "📦 Mở APK installer..."
termux-open "$TARGET_DIR/install/winlator.apk"

# -------- Step 8: Done --------
echo "======================================"
echo "🎉 Hoàn tất!"
echo "Game data nằm tại:"
echo "$GAME_DIR"
echo ""
echo "Vui lòng bấm INSTALL khi APK mở ra."
echo "======================================"