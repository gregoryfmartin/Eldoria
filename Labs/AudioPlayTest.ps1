# $PlaySong = $true
# $SongIsPlaying = $false

$rs          = [RunspaceFactory]::CreateRunspace()
$ps          = [PowerShell]::Create()
$ps.Runspace = $rs
$rs.Open()
$ps.AddScript({
    $Global:a = New-Object 'System.Media.SoundPlayer'
    $Global:a.SoundLocation = './Test.wav'
    $Global:a.PlaySync()
})
$a = $ps.BeginInvoke()

# $PlayJob = Start-Job -ScriptBlock {
# $a               = New-Object 'System.Media.SoundPlayer'
# $a.SoundLocation = './Test.wav'
#     If($PlaySong -AND -NOT($SongIsPlaying)) {
#         $a.PlaySync()
#         $SongIsPlaying = $true   
#     }
#     }

Write-Output 'Playing the wav file. Enojy!'

Read-Host

$ps.EndInvoke($a)
$rs.Close()
$ps = $null

# $PlaySong = $false

# Stop-Job -Id $PlayJob.Id