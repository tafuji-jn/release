#!/bin/bash
#
# ThinMonitorTool インストールスクリプト
#
# 使い方:
#   curl -fsSL https://raw.githubusercontent.com/tafuji-jn/release/main/thinmonitortool/install.sh | bash
#
# オプション:
#   INSTALL_DIR=/path/to/dir  インストール先を指定（デフォルト: ~/thinmonitortool）
#

set -e

# 色付き出力
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  ThinMonitorTool インストーラー${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""

# インストール先ディレクトリ
INSTALL_DIR="${INSTALL_DIR:-$HOME/thinmonitortool}"

# ダウンロードURL
VERSION_URL="https://raw.githubusercontent.com/tafuji-jn/release/main/thinmonitortool/version.json"
ZIP_URL="https://raw.githubusercontent.com/tafuji-jn/release/main/thinmonitortool/releases/latest.zip"

echo -e "${YELLOW}インストール先: ${INSTALL_DIR}${NC}"
echo ""

# 既存のインストールがあるか確認
if [ -d "$INSTALL_DIR" ]; then
    echo -e "${YELLOW}警告: ${INSTALL_DIR} は既に存在します。${NC}"
    read -p "上書きしますか？ (y/N): " confirm < /dev/tty
    if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
        echo "インストールを中止しました。"
        exit 0
    fi
fi

# 必要なパッケージをインストール
echo -e "${GREEN}[1/5] システムパッケージをインストール中...${NC}"
sudo apt update
sudo apt install -y \
    python3 python3-venv python3-pip \
    curl unzip \
    python3-pyqt5 \
    libxcb-xinerama0 \
    bluez bluetooth \
    fonts-noto-cjk

# バージョン情報を取得
echo -e "${GREEN}[2/5] バージョン情報を取得中...${NC}"
VERSION_INFO=$(curl -fsSL "$VERSION_URL")
VERSION=$(echo "$VERSION_INFO" | grep -o '"version"[[:space:]]*:[[:space:]]*"[^"]*"' | cut -d'"' -f4)
COMMIT=$(echo "$VERSION_INFO" | grep -o '"commit"[[:space:]]*:[[:space:]]*"[^"]*"' | cut -d'"' -f4)
DATE=$(echo "$VERSION_INFO" | grep -o '"date"[[:space:]]*:[[:space:]]*"[^"]*"' | cut -d'"' -f4)

echo "  バージョン: $VERSION"
echo "  コミット: $COMMIT"
echo "  日付: $DATE"
echo ""

# ZIPをダウンロード
echo -e "${GREEN}[3/5] アプリケーションをダウンロード中...${NC}"
TEMP_DIR=$(mktemp -d)
curl -fsSL "$ZIP_URL" -o "$TEMP_DIR/app.zip"

# 展開
echo -e "${GREEN}[4/5] ファイルを展開中...${NC}"
mkdir -p "$INSTALL_DIR"
unzip -o "$TEMP_DIR/app.zip" -d "$INSTALL_DIR"

# バージョンファイルを作成
cat > "$INSTALL_DIR/.version" << EOF
{
  "version": "$VERSION",
  "commit": "$COMMIT",
  "date": "$DATE"
}
EOF

# クリーンアップ
rm -rf "$TEMP_DIR"

# Python仮想環境をセットアップ
echo -e "${GREEN}[5/5] Python環境をセットアップ中...${NC}"
cd "$INSTALL_DIR"
python3 -m venv --system-site-packages venv
source venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt

# 実行権限を付与
chmod +x start.sh

echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  インストール完了！${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo "次のステップ:"
echo ""
echo "1. 認証ファイルを配置:"
echo "   - credentials.json (Google Calendar)"
echo "   - spotify_credentials.json (Spotify)"
echo ""
echo "2. アプリを起動:"
echo "   cd $INSTALL_DIR"
echo "   ./start.sh"
echo ""
echo "3. 自動起動を設定する場合:"
echo "   crontab -e"
echo "   @reboot $INSTALL_DIR/start.sh"
echo ""
