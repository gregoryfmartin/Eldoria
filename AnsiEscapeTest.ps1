# This page is amazing https://duffney.io/usingansiescapesequencespowershell/
# Double-quotations are virtually required beyond this point for all of the ANSI ES to work correctly

Class GfmConsoleColor24 {
    [ValidateRange(0, 255)][Int]$r
    [ValidateRange(0, 255)][Int]$g
    [ValidateRange(0, 255)][Int]$b
    
    GfmConsoleColor24(
        [Int]$r,
        [Int]$g,
        [Int]$b
    ) {
        $this.r = [System.Math]::Clamp($r, 0, 255)
        $this.g = [System.Math]::Clamp($g, 0, 255)
        $this.b = [System.Math]::Clamp($b, 0, 255)
    }
}

Class GfmCCBlack24: GfmConsoleColor24 { GfmCCBlack24() : base(0, 0, 0) {} }
Class GfmCCWhite24: GfmConsoleColor24 { GfmCCWhite24() : base(255, 255, 255) {} }
Class GfmCCRed24  : GfmConsoleColor24 { GfmCCRed24() : base(255, 0, 0) {}}
Class GfmCCGreen24: GfmConsoleColor24 { GfmCCGreen24() : base(0, 255, 0) {}}
Class GfmCCBlue24 : GfmConsoleColor24 { GfmCCBlue24() : base (0, 0, 255) {}}

Class GfmATForegroundColor24 {
    [ValidateNotNullOrEmpty()][GfmConsoleColor24]$c
    
    GfmATForegroundColor24(
        [GfmConsoleColor24]$c
    ) {
        $this.c = $c
    }
    
    [String]ToAnsiEscapedString() {
        Return "`e[38;2;$($this.c.r.ToString());$($this.c.g.ToString());$($this.c.b.ToString())m"
    }
}

Class GfmATBackgroundColor24 {
    [ValidateNotNullOrEmpty()][GfmConsoleColor24]$c
    
    GfmATBackgroundColor24(
        [GfmConsoleColor24]$c
    ) {
        $this.c = $c
    }
    
    [String]ToAnsiEscapedString() {
        Return "`e[48;2;$($this.c.r.ToString());$($this.c.g.ToString());$($this.c.b.ToString())m"
    }
}

Class GfmATBackgroundColor24None : GfmATBackgroundColor24 {
    GfmATBackgroundColor24None() : base([GfmCCBlack24]::new()) {}
    
    [String]ToAnsiEscapedString() {
        Return ""
    }
}

Class GfmATDecoration {
    [ValidateNotNullOrEmpty()][Boolean]$blink
    
    GfmATDecoration(
        [Boolean]$blink
    ) {
        $this.blink = $blink
    }
    
    [String]ToAnsiEscapedString() {
        [String]$a = ""
        
        If($this.blink) {
            $a += "`e[5m"
        }
        
        Return $a
    }
}

Class GfmATCoordinates {
    [ValidateNotNullOrEmpty()][Int]$r
    [ValidateNotNullOrEmpty()][Int]$c
    
    GfmATCoordinates(
        [Int]$r,
        [Int]$c
    ) {
        $this.r = $r
        $this.c = $c
    }
    
    [String]ToAnsiEscapedString() {
        Return "`e[$($this.r.ToString());$($this.c.ToString())H"
    }
}

Class GfmATCoordinatesNone : GfmATCoordinates {
    GfmATCoordinatesNone() : base(0, 0) {}
    
    [String]ToAnsiEscapedString() {
        Return ''
    }
}

Class GfmATReset {
    [String]ToAnsiEscapedString() {
        Return "`e[0m"
    }
}

Class GfmATString {
    [GfmATForegroundColor24]$fgColor
    [GfmATBackgroundColor24]$bgColor
    [GfmATDecoration]$decor
    [GfmATCoordinates]$coords
    [String]$message
    
    GfmATString(
        [GfmATForegroundColor24]$fgColor,
        [GfmATBackgroundColor24]$bgColor,
        [GfmATDecoration]$decor,
        [GfmATCoordinates]$coords,
        [String]$message
    ) {
        $this.fgColor = $fgColor
        $this.bgColor = $bgColor
        $this.decor   = $decor
        $this.coords  = $coords
        $this.message = $message
    }
    
    [String]ToAnsiEscapedString() {
        Return "$($this.coords.ToAnsiEscapedString())$($this.decor.ToAnsiEscapedString())$($this.fgColor.ToAnsiEscapedString())$($this.bgColor.ToAnsiEscapedString())$($this.message)$([GfmATReset]::new().ToAnsiEscapedString())"
    }
    
    [String]ToAnsiControlSequencesPrefixString() {
        Return "$($this.coords.ToAnsiEscapedString())$($this.decor.ToAnsiEscapedString())$($this.fgColor.ToAnsiEscapedString())$($this.bgColor.ToAnsiEscapedString())"
    }
}

[Flags()] Enum TtySpeed {
    SuperSlow = 1000000
    Slow      = 750000
    Normal    = 100000
    Moderate  = 75000
    Quick     = 65000
    Fast      = 50000
    SuperFast = 25000
    LineClear = 1
}

Function Write-GfmHostNnl {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)]
        [GfmATString]$ATString
    )
    
    Process {
        Write-Host $ATString.ToAnsiEscapedString() -NoNewline
    }
}

Function Write-GfmTtyString {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)]
        [GfmATString]$ATString,
        [Parameter(Mandatory = $false)]
        [TtySpeed]$TypeSpeed = [TtySpeed]::Normal
    )
    
    Process {
        # Write the prefix control sequences first
        Write-Host "$($ATString.coords.ToAnsiEscapedString())$($ATString.decor.ToAnsiEscapedString())$($ATString.fgColor.ToAnsiEscapedString())$($ATString.bgColor.ToAnsiEscapedString())" -NoNewline
        #"$($ATString.coords.ToAnsiEscapedString())$($ATString.decor.ToAnsiEscapedString())$($ATString.fgColor.ToAnsiEscapedString())$($ATString.bgColor.ToAnsiEscapedString())" | Write-Information -InformationAction SilentlyContinue
        
        # Teletype the message using the legacy algorithm
        [Char[]]$msgCharArray = $ATString.message.ToCharArray()
        [Int]   $typeCounter  = 0
        [Int]   $msgcaProbe   = 0

        While($msgcaProbe -LE ($msgCharArray.Count - 1)) {
            $typeCounter++
            If($typeCounter -GE $TypeSpeed) {
                $typeCounter = 0
                Write-Host $msgCharArray[$msgcaProbe] -NoNewline
                #$msgCharArray[$msgcaProbe] | Write-Information -InformationAction Continue
                $msgcaProbe++
            }
        }
        
        # Write the suffix reset control sequence
        Write-Host $([GfmATReset]::new().ToAnsiEscapedString()) -NoNewline
        #$([GfmATReset]::new().ToAnsiEscapedString()) | Write-Information -InformationAction SilentlyContinue
    }
}

#Write-GfmHostNnl -ATString $([GfmATString]::new([GfmCCRed24]::new(), [GfmATBackgroundColor24None]::new(), [GfmATDecoration]::new($false), [GfmATCoordinatesNone]::new(), 'Hello, world!'))

Write-GfmTtyString -ATString $([GfmATString]::new([GfmCCGreen24]::new(), [GfmATBackgroundColor24None]::new(), [GfmATDecoration]::new($false), [GfmATCoordinatesNone]::new(), 'Hello, world!'))

#Write-Host $([GfmATString]::new([GfmCCRed24]::new(), [GfmATBackgroundColor24None]::new(), [GfmATDecoration]::new($false), [GfmATCoordinatesNone]::new(), 'Hello, world!')).ToAnsiControlSequencesPrefixString()"Boo!" -NoNewline

