# タスクを起こした後の確認。heartbeat.json が、この版でこの確認より後の時刻を示すまで 60 秒待つ。
# この版の deploy\FAIL_CHECK があれば失敗する（前の版に戻す動きの試験用。release ワークフローの fail_check で入る）
$ErrorActionPreference = "Stop"
if (Test-Path -LiteralPath (Join-Path $PSScriptRoot "FAIL_CHECK")) {
    Write-Output "FAIL_CHECK があるので失敗にする"
    exit 1
}
$file = Join-Path $env:APP_DATA "heartbeat.json"
$since = [DateTimeOffset]::Now
while ([DateTimeOffset]::Now -lt $since.AddSeconds(60)) {
    $beat = $null
    $fresh = $false
    # ファイルがまだない、置き換えの途中で読めない、といったときは次を待つ
    try {
        $beat = Get-Content -LiteralPath $file -Raw -Encoding UTF8 | ConvertFrom-Json
        $fresh = $beat.version -eq $env:APP_TO_VERSION -and [DateTimeOffset]$beat.time -gt $since
    } catch { }
    if ($fresh) {
        Write-Output "heartbeat: $($beat.version) $($beat.time) pid $($beat.pid)"
        exit 0
    }
    Start-Sleep -Seconds 2
}
Write-Output "60 秒たっても $env:APP_TO_VERSION の heartbeat が来ない（最後: $($beat.version) $($beat.time)）"
exit 1
