# ThinMonitorTool

Raspberry Pi用モニターツール。Spotify制御、Googleカレンダー表示などの機能を持つ。

## インストール方法

Raspberry Piで以下のコマンドを実行：

```bash
curl -fsSL https://raw.githubusercontent.com/tafuji-jn/release/main/thinmonitortool/install.sh | bash
```

## 認証ファイルの準備

### credentials.json（Google Calendar用）

1. [Google Cloud Console](https://console.cloud.google.com/) にアクセス
2. プロジェクトを作成（または既存のを選択）
3. 「APIとサービス」→「ライブラリ」→「Google Calendar API」を有効化
4. 「APIとサービス」→「認証情報」→「認証情報を作成」→「OAuthクライアントID」
5. アプリの種類:「デスクトップアプリ」を選択
6. 作成後「JSONをダウンロード」→ `credentials.json` として保存

### spotify_credentials.json（Spotify用）

1. [Spotify Developer Dashboard](https://developer.spotify.com/dashboard) にアクセス
2. 「Create App」をクリック
3. アプリ名、説明を入力
4. Redirect URI に `http://localhost:8888/callback` を追加
5. 作成後「Settings」からClient IDとClient Secretを確認
6. 以下の形式でJSONファイルを作成：

```json
{
  "client_id": "ここにClient ID",
  "client_secret": "ここにClient Secret",
  "redirect_uri": "http://localhost:8888/callback"
}
```

## セットアップ手順

### 1. 認証ファイルを配置

上記で作成したファイルをインストールディレクトリに配置：

```bash
scp credentials.json pi@raspberrypi:~/thinmonitortool/
scp spotify_credentials.json pi@raspberrypi:~/thinmonitortool/
```

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

