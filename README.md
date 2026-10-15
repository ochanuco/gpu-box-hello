# gpu-box-hello

chabatake の GPU 機の配備（`gpu-box-app` ワークフロー）を試すためのアプリ。GPU 機に載せるアプリ repo のひな形も兼ねる。配備のしくみ、フック、許可リストは chabatake の [docs/gpu-box-apps.md](https://github.com/ochanuco/chabatake/blob/main/docs/gpu-box-apps.md) にある。

| パス | 内容 |
|---|---|
| `hello.ps1` | ログオン時のタスク `gpu-box-hello` が `C:\apps\gpu-box-hello\current` から動かす。15 秒ごとに時刻と版を `C:\apps\gpu-box-hello\data\heartbeat.json` に書く |
| `register.ps1` | 初回設定。GPU 機の管理者権限の PowerShell で一度だけ実行し、`data\` とタスクを用意する |
| `deploy/prepare.ps1` | 渡る環境変数と作業フォルダを見せる |
| `deploy/check.ps1` | heartbeat.json が新しい版を示すまで待つ。`deploy/FAIL_CHECK` があれば失敗する |
| `ops/hello.ps1` | op `hello`。引数と環境変数を見せる |
| `.github/workflows/release.yml` | zip を作って Release を公開する。`fail_check` を付けると check が失敗する版になる |

## 試し方

1. GPU 機で `register.ps1` を実行する。
2. release ワークフローを実行し、Release のタグ（`r<run 番号>-<sha 先頭 7 桁>`）を確かめる。
3. chabatake の gpu-box-app を dispatch する。

```sh
gh workflow run gpu-box-app.yml -R ochanuco/chabatake --ref production \
  -f app=gpu-box-hello -f action=deploy -f version=<タグ>
```
