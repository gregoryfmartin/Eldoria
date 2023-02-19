$rhost = $(Get-Host).UI.RawUI
[String]$sampleString = 'Hello, scroller!'
[Int]$bufferWidth = 80
[Int]$bufferHeight = 30


Clear-Host

# Draw the text to the buffer
$rhost.CursorPosition = [System.Management.Automation.Host.Coordinates]::new(($bufferWidth / 2) - ($sampleString.Length / 2), 10)
Write-Host $sampleString
Read-Host

# Attempt to scroll the contents of the buffer so that the text goes off the top of the screen
$rhost.ScrollBufferContents(
    [System.Management.Automation.Host.Rectangle]  : : new(0, 0, $bufferWidth, $bufferHeight),
    [System.Management.Automation.Host.Coordinates]: : new(-5, -5),
    [System.Management.Automation.Host.Rectangle]  : : new(0, 0, $bufferWidth, $bufferHeight),
    [System.Management.Automation.Host.BufferCell] : : new(' ', 0, 0, 0)
)

