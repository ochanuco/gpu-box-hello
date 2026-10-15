# ログオン時のタスク gpu-box-hello が C:\apps\gpu-box-hello\current\hello.ps1 として動かす。
# 15 秒ごとに、今の時刻と自分の版（隣の release.json）を data\heartbeat.json に書く。
$ErrorActionPreference = "Stop"
$release = Get-Content -LiteralPath (Join-Path $PSScriptRoot "release.json") -Raw -Encoding UTF8 | ConvertFrom-Json
$out = "C:\apps\gpu-box-hello\data\heartbeat.json"
$tmp = "$out.tmp"
while ($true) {
    $beat = [ordered]@{
        version = $release.version
        commit  = $release.commit
        time    = (Get-Date).ToString("o")
        pid     = $PID
    }
    # check が書きかけを読まないよう、別の名前で書いてから置き換える
    [IO.File]::WriteAllText($tmp, ($beat | ConvertTo-Json), (New-Object Text.UTF8Encoding $false))
    Move-Item -LiteralPath $tmp -Destination $out -Force
    Start-Sleep -Seconds 15
}
