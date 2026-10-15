# op hello。chabatake の許可リストにある固定の引数と、渡る環境変数を見せる
Write-Output "引数: $($args.Count) 個"
for ($i = 0; $i -lt $args.Count; $i++) { Write-Output "  [$i] $($args[$i])" }
Write-Output "作業フォルダ: $((Get-Location).Path)"
Get-ChildItem Env:APP_* | Sort-Object Name | ForEach-Object { Write-Output "$($_.Name)=$($_.Value)" }
