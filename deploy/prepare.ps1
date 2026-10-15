# 切り替えの前の準備。gpu-box-hello では、chabatake から渡る環境変数と作業フォルダを見せるだけ
Write-Output "作業フォルダ: $((Get-Location).Path)"
Get-ChildItem Env:APP_* | Sort-Object Name | ForEach-Object { Write-Output "$($_.Name)=$($_.Value)" }
