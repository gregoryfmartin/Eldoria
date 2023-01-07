[Int]$frameRate = 30
[Single]$frameMs = 1000 / $frameRate

while(1) {
    $startMs = Get-Date
    # Do something here
    Write-Host 'Buffalo farts, those are the best'
    $endMs = Get-Date
    # $msDelta = $(New-TimeSpan -Start $startMs -End $endMs).TotalMilliseconds; Write-Host $msDelta
    # $delayMs = $frameMs - $msDelta; Write-Host $delayMs
    Start-Sleep -Milliseconds ($frameMs - $(New-TimeSpan -Start $startMs -End $endMs).TotalMilliseconds)
}