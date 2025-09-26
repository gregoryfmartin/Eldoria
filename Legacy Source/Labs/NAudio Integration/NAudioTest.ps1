Set-StrictMode -Version Latest

Add-Type -Path .\Libs\NAudio.dll
Add-Type -Path .\Libs\NAudio.Wasapi.dll
Add-Type -Path .\Libs\NAudio.WinMM.dll

[NAudio.Wave.WaveOutEvent]$WaveOut            = [NAudio.Wave.WaveOutEvent]::new()
[NAudio.Wave.AudioFileReader]$AudioFileReader = [NAudio.Wave.AudioFileReader]::new("$PSScriptRoot\Player Setup Theme A.wav")

$WaveOut.Init($AudioFileReader)
$WaveOut.Play()