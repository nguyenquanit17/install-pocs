#!/data/data/com.termux/files/usr/bin/bash
set -e

TARGET_DIR="$HOME/storage/downloads/GamiQ/YUGIOHPOC"

# -------- Input --------
if [ -z "$1" ]; then
  echo "Usage:"
  echo "curl -L https://yourhost.com/download.sh | bash -s \"FILE_ID1|FILE_ID2|FILE_ID3\""
  exit 1
fi

IFS='|' read -ra FILE_IDS <<< "$1"  # split by |

# -------- Dependencies --------
pkg install -y python unzip
pip install --no-cache-dir gdown

# -------- Storage --------
if [ ! -d "$HOME/storage" ]; then
  echo "📂 Request storage permission..."
  termux-setup-storage
  echo "⚠️ Please rerun script after granting storage permission."
  exit 1
fi

mkdir -p "$TARGET_DIR"

# -------- Download loop --------
TOTAL=${#FILE_IDS[@]}
COUNT=0

for FILE_ID in "${FILE_IDS[@]}"; do
  COUNT=$((COUNT+1))
  ZIP_FILE="$TARGET_DIR/tmp_file_$COUNT.zip"
  echo "⬇️ [$COUNT/$TOTAL] Downloading https://drive.google.com/uc?id=$FILE_ID ..."
  gdown "https://drive.google.com/uc?id=$FILE_ID" -O "$ZIP_FILE"

  echo "📦 Extracting..."
  unzip -P gamiQ -o "$ZIP_FILE" -d "$TARGET_DIR"

  rm "$ZIP_FILE"
done

echo "======================================"
echo "✅ All downloads complete!"
echo "Game data is in: $TARGET_DIR"
echo "======================================"