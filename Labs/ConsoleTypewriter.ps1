[Flags()] Enum TtySpeed {
    SuperSlow = 1000000
    Slow   = 750000
    Normal = 100000
    Moderate = 75000
    Quick = 65000
    Fast = 50000
    SuperFast = 25000
}

[String]$sampleStr = "Hello, world!"
[Char[]]$sampleStrCharArray = $sampleStr.ToCharArray()
[Int]$sampleStrPrintCounter = 0
[TtySpeed]$sampleStrPrintDelimiter = [TtySpeed]::SuperFast
[Int]$sampleStrProbe = 0
while($sampleStrProbe -LE ($sampleStrCharArray.Count - 1)) {
    $sampleStrPrintCounter++
    If($sampleStrPrintCounter -GE $sampleStrPrintDelimiter) {
        $sampleStrPrintCounter = 0
        Write-Host $sampleStrCharArray[$sampleStrProbe] -NoNewline
        $sampleStrProbe++
    }
}