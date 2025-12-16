using namespace System.Management.Automation

Set-StrictMode -Version Latest

$Runs = [RunspaceFactory]::CreateRunspace()
$Runs.Open()

$PSInstance = [PowerShell]::Create()
$PSInstance.Runspace = $Runs

$InputData = ''

$PSInstance.AddScript({
    $KeyRead = [Console]::ReadKey($true)
    $InputData = $KeyRead.KeyChar
})

$AsyncResult = $PSInstance.BeginInvoke()

$KeyInfo = $null

$Running = $true

While($Running) {
    If($AsyncResult.IsCompleted -EQ $false) {
        Continue
    } ElseIf($AsyncResult.IsCompleted -EQ $true) {
        $KeyInfo = $PSInstance.EndInvoke($AsyncResult) | Select-Object -First 1
        Write-Host "Key pressed: $($KeyInfo.Key) Char: $($KeyInfo.KeyChar)"
    }
}

<#
While($AsyncResult.IsCompleted -EQ $false) {
    Write-Host 'Waiting for input...'
}

If($AsyncResult.IsCompleted -EQ $true) {
    $KeyInfo = $PSInstance.EndInvoke($AsyncResult) | Select-Object -First 1
    Write-Host "Key Pressed: $($KeyInfo.Key) Char: $($KeyInfo.KeyChar)"
}
#>

$PSInstance.Dispose()
$Runs.Dispose()
