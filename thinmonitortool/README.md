# ThinMonitorTool

Raspberry Pi用モニターツール。Spotify制御、Googleカレンダー表示などの機能を持つ。

## インストール方法

Raspberry Piで以下のコマンドを実行：

```bash
curl -fsSL https://raw.githubusercontent.com/tafuji-jn/release/main/thinmonitortool/install.sh | bash
```

## インストール後の設定

### 1. 認証ファイルを配置

以下のファイルをインストールディレクトリ（`~/thinmonitortool`）に配置：

- `credentials.json` - Google Calendar API認証情報
- `spotify_credentials.json` - Spotify API認証情報

### 2. アプリを起動

```bash
cd ~/thinmonitortool
./start.sh
```

### 3. 認証を実行

アプリ起動後、設定メニュー（画面左端からスワイプ）から：

- 「Google カレンダー認証」- QRコードをスマホでスキャンして認証
- 「Spotify 認証」- ブラウザで認証

## 自動起動設定

Raspberry Pi起動時に自動起動するには：

```bash
crontab -e
```

以下の行を追加：

```
@reboot ~/thinmonitortool/start.sh
```

## 更新方法

アプリの設定メニューから「アプリ更新チェック」をタップ。

