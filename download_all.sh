#!/data/data/com.termux/files/usr/bin/bash
set -e

echo "======================================"
echo "    YUGIOH POC DOWNLOAD ALL v1"
echo "======================================"

# -------- CONFIG --------
TARGET_DIR="$HOME/storage/downloads/GamiQ/YUGIOHPOC"
# Danh sách Google Drive links (1 link 1 dòng)
LINKS=(
"https://drive.google.com/uc?id=1fcFXZllDk4gS-NmuTpIi4OXcT_NONjc7"
"https://drive.google.com/uc?id=11pc9hJhuVLgEfQH8ZRmNnFk"
# thêm link khác ở đây
)
# ------------------------

# -------- Install dependencies --------
pkg install -y python
pip install --no-cache-dir gdown

# -------- Storage permission --------
if [ ! -d "$HOME/storage" ]; then
    echo "📂 Storage permission chưa cấp. Yêu cầu cấp..."
    termux-setup-storage
    echo "⚠️ Vui lòng rerun script sau khi cấp quyền storage."
    exit 0
fi

# -------- Prepare target directory --------
mkdir -p "$TARGET_DIR"

# -------- Download files --------
TOTAL=${#LINKS[@]}
COUNT=0

for LINK in "${LINKS[@]}"; do
    COUNT=$((COUNT+1))
    echo "🔽 [$COUNT/$TOTAL] Downloading: $LINK"
    gdown "$LINK" -O "$TARGET_DIR"
done

echo "🎉 Hoàn tất tất cả các file!"
echo "Files đã lưu tại: $TARGET_DIR"