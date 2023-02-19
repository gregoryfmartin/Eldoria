# [Int]    $frameRate = 30
# [Single]$frameMs    = 1000 / $frameRate

# while(1) {
#     $startMs = Get-Date
#     # Do something here
#     Write-Host 'Buffalo farts, those are the best'
#                                                                                                                                               $endMs   = Get-Date
#                                                                                                                                             # $msDelta = $(New-TimeSpan -Start $startMs -End $endMs).TotalMilliseconds; Write-Host $msDelta
#                                                                                                                                             # $delayMs = $frameMs - $msDelta; Write-Host $delayMs
#     Start-Sleep -Milliseconds ($frameMs - $(New-TimeSpan -Start $startMs -End $endMs).TotalMilliseconds)
# }638093363768624147 - 638093363768570639

[Int]$framerate = 30
[Int]$fc        = (1000 / $framerate)
[Double]$lastframetime
[Double]$currentframetime

while(1) {
    $currentframetime = [datetime]::Now.Ticks
    Write-Host "Current Frame Time is $currentframetime, and Last Frame Time is $lastframetime"
    if(($currentframetime - $lastframetime) -GE $fc) {
        [TimeSpan]$ts = [TimeSpan]::new($currentframetime - $lastframetime)
        Write-Host "$($ts.TotalSeconds)"
        $lastframetime = $currentframetime
        Write-Host 'Executing frame'
    }
}