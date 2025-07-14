using namespace System.Management.Automation

Set-StrictMode -Version Latest

$Runs = [RunspaceFactory]::CreateRunspace()
$Runs.Open()

$PSInstance = [PowerShell]::Create()
$PSInstance.Runspace = $Runs

$PSInstance.AddScript({
    [Console]::ReadKey($true)
})

$AsyncResult = $PSInstance.BeginInvoke()

$KeyInfo = $null

While($AsyncResult.IsCompleted -EQ $false) {
    Write-Host 'Waiting for input...'
}

If($AsyncResult.IsCompleted -EQ $true) {
    $KeyInfo = $PSInstance.EndInvoke($AsyncResult) | Select-Object -First 1
    Write-Host "Key Pressed: $($KeyInfo.Key) Char: $($KeyInfo.KeyChar)"
}

$PSInstance.Dispose()
$Runs.Dispose()
