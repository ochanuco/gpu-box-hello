# GPU 機で一度だけ、管理者権限の PowerShell から実行する。データの置き場所を作り、ログオン時のタスク gpu-box-hello を登録する。
# タスクは起こさない。current は最初の配備（chabatake の gpu-box-app ワークフロー）で作られる。
$ErrorActionPreference = "Stop"
$TaskName = "gpu-box-hello"
New-Item -ItemType Directory -Force -Path "C:\apps\gpu-box-hello\data" | Out-Null

# 配備は chanu の非昇格の runner がタスクを止めて起こすので、タスクも chanu の非昇格で動かす
$action = New-ScheduledTaskAction -Execute "powershell.exe" `
    -Argument "-NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File C:\apps\gpu-box-hello\current\hello.ps1"
$trigger = New-ScheduledTaskTrigger -AtLogOn -User "chanu"
$principal = New-ScheduledTaskPrincipal -UserId "chanu" -LogonType Interactive -RunLevel Limited
$settings = New-ScheduledTaskSettingsSet -ExecutionTimeLimit ([TimeSpan]::Zero) `
    -RestartCount 3 -RestartInterval (New-TimeSpan -Minutes 1) `
    -DontStopIfGoingOnBatteries -AllowStartIfOnBatteries
Register-ScheduledTask -TaskName $TaskName -Action $action -Trigger $trigger `
    -Principal $principal -Settings $settings -Force | Out-Null
Get-ScheduledTask -TaskName $TaskName | Select-Object TaskName, State
