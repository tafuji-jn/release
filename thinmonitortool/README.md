# ThinMonitorTool

Raspberry Pi用モニターツール。Spotify制御、Googleカレンダー表示などの機能を持つ。

## インストール方法

Raspberry Piで以下のコマンドを実行：

```bash
curl -fsSL https://raw.githubusercontent.com/tafuji-jn/release/main/thinmonitortool/install.sh | bash
```

## 認証セットアップ

Raspberry Piはブラウザ認証が難しいため、**Windows PCで認証を行い、トークンファイルをコピー**します。

### 1. API認証情報の準備

#### credentials.json（Google Calendar用）

1. [Google Cloud Console](https://console.cloud.google.com/) にアクセス
2. プロジェクトを作成（または既存のを選択）
3. 「APIとサービス」→「ライブラリ」→「Google Calendar API」を有効化
4. 「APIとサービス」→「認証情報」→「認証情報を作成」→「OAuthクライアントID」
5. アプリの種類:「デスクトップアプリ」を選択
6. 作成後「JSONをダウンロード」→ `credentials.json` として保存

#### spotify_credentials.json（Spotify用）

1. [Spotify Developer Dashboard](https://developer.spotify.com/dashboard) にアクセス
2. 「Create App」をクリック
3. アプリ名、説明を入力
4. Redirect URI に `http://127.0.0.1:8888/callback` を追加
5. 作成後「Settings」からClient IDとClient Secretを確認
6. 以下の形式でJSONファイルを作成：

```json
{
  "client_id": "ここにClient ID",
  "client_secret": "ここにClient Secret",
  "redirect_uri": "http://127.0.0.1:8888/callback"
}
```

### 2. Windows PCで認証を実行

1. [auth_setup.exe をダウンロード](https://raw.githubusercontent.com/tafuji-jn/release/main/thinmonitortool/auth_setup.exe)
2. `credentials.json` と `spotify_credentials.json` を同じフォルダに配置
3. `auth_setup.exe` を実行（ブラウザが開いて認証）

### 3. Raspberry Piにファイルをコピー

認証完了後、以下のファイルをRaspberry Piにコピー：

- `credentials.json`
- `token.pickle`
- `spotify_credentials.json`
- `.spotify_token_cache`

```bash
scp credentials.json token.pickle spotify_credentials.json .spotify_token_cache pi@raspberrypi:~/thinmonitortool/
```

### 4. アプリを起動

```bash
cd ~/thinmonitortool
./start.sh
```

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
