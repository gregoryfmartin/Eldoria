Describe 'New-EldAnsiFg24Prefix' {
    BeforeAll {
        . "$PSScriptRoot\..\Private\Ansi.ps1" ; Initialize-EldVars
    }

    It 'Creates a SGR FG24 string with an array (white)' {
        New-EldAnsiFg24Prefix -ArrData @(255, 255, 255) | Should -BeExactly "`e[38;2;255;255;255m"
    }

    It 'Creates a SGR FG24 string with a PSVariable (CCWhite24)' {
        New-EldAnsiFg24Prefix -PSVData (Get-EldVar -Name 'CCWhite24') | Should -BeExactly "`e[38;2;255;255;255m"
    }

    It 'Creates an empty string with the Empty switch' {
        New-EldAnsiFg24Prefix -Empty -ArrData @() | Should -BeExactly ''
    }

    AfterAll {
        Remove-EldVars
    }
}

Describe 'New-EldAnsiBg24Prefix' {
    BeforeAll {
        . "$PSScriptRoot\..\Private\Ansi.ps1" ; Initialize-EldVars
    }

    It 'Creates a SGR BG24 string with an array (white)' {
        New-EldAnsiBg24Prefix -ArrData @(255, 255, 255) | Should -BeExactly "`e[48;2;255;255;255m"
    }

    It 'Creates a SGR BG24 string with a PSVariable (CCWhite24)' {
        New-EldAnsiBg24Prefix -PSVData (Get-EldVar -Name 'CCWhite24') | Should -BeExactly "`e[48;2;255;255;255m"
    }

    It 'Creates an empty string with the Empty switch' {
        New-EldAnsiBg24Prefix -Empty -ArrData @() | Should -BeExactly ''
    }

    AfterAll {
        Remove-EldVars
    }
}

Describe 'New-EldAnsiCursorCoordPrefix' {
    BeforeAll {
        . "$PSScriptRoot\..\Private\Ansi.ps1" ; Initialize-EldVars
    }

    It 'Creates a CSI string to position the cursor using default values (1, 1)' {
        New-EldAnsiCursorCoordPrefix | Should -BeExactly "`e[1;1H"
    }

    It 'Creates a CSI string to position the cursor at custom coordinates (5, 5)' {
        New-EldAnsiCursorCoordPrefix -Row 5 -Column 5 | Should -BeExactly "`e[5;5H"
    }

    It 'Creates an empty string with the Empty switch' {
        New-EldAnsiCursorCoordPrefix -Empty | Should -BeExactly ''
    }

    It 'Throws an exception if provided data for either Row or Column are out of range' {
        { New-EldAnsiCursorCoordPrefix -Row -5 -Column 500 } | Should -Throw
    }

    AfterAll {
        Remove-EldVars
    }
}

Describe 'New-EldAnsiDecoPrefix' {
    BeforeAll {
        . "$PSScriptRoot\..\Private\Ansi.ps1" ; Initialize-EldVars
    }

    It 'Creates an empty string with no options supplied' {
        New-EldAnsiDecoPrefix | Should -BeExactly ''
    }

    It 'Creates an empty string with the Empty switch' {
        New-EldAnsiDecoPrefix -Empty | Should -BeExactly ''
    }

    It 'Creates a SGR string with all supported decorators (blink, italic, underline, strikethru)' {
        New-EldAnsiDecoPrefix -Blink -Italic -Underline -Strikethru `
            | Should -BeExactly "`e[5m`e[3m`e[4m`e[9m"
    }

    It 'Creates a SGR string with only the underline decorator' {
        New-EldAnsiDecoPrefix -Underline | Should -BeExactly "`e[4m"
    }
    
    AfterAll {
        Remove-EldVars
    }
}

Describe 'New-EldAtPrefix' {
    BeforeAll {
        . "$PSScriptRoot\..\Private\Ansi.ps1" ; Initialize-EldVars
    }

    It 'Creates an empty string with no options supplied' {
        New-EldAtPrefix | Should -BeExactly ''
    }

    It 'Creates an empty string with the Empty switch' {
        New-EldAtPrefix -Empty | Should -BeExactly ''
    }

    It 'Creates an AT Prefix with white foreground color only' {
        New-EldAtPrefix -Fg24 @{ ArrData = @(255, 255, 255) } | Should -BeExactly "`e[38;2;255;255;255m"
    }

    It 'Creates an AT prefix with white background color only' {
        New-EldAtPrefix -Bg24 @{ ArrData = @(255, 255, 255) } | Should -BeExactly "`e[48;2;255;255;255m"
    }

    It 'Creates an AT Prefix with a Blink decoration only' {
        New-EldAtPrefix -Deco @{ Blink = $true } | Should -BeExactly "`e[5m"
    }

    It 'Creates an AT Prefix with cursor coordinate changes only (5, 5)' {
        New-EldAtPrefix -Coords @{ Row = 5; Column = 5 } | Should -BeExactly "`e[5;5H"
    }

    It 'Creates an AT Prefix with white foreground, white background, blink decoration, and cursor coordinate changes' {
        [Hashtable]$Vals = @{
            Fg24 = @{ ArrData = @(255, 255, 255) }
            Bg24 = @{ ArrData = @(255, 255, 255) }
            Deco = @{ Blink = $true }
            Coords = @{ Row = 5; Column = 5 }
            Empty = $false
        }
        
        New-EldAtPrefix @Vals | Should -BeExactly "`e[38;2;255;255;255m`e[48;2;255;255;255m`e[5m`e[5;5H"
    }

    AfterAll {
        Remove-EldVars
    }
}

Describe 'New-EldAtString' {
    BeforeAll {
        . "$PSScriptRoot\..\Private\Ansi.ps1" ; Initialize-EldVars
    }

    It 'Creates an empty string with no options supplied' {
        New-EldAtString | Should -BeExactly ''
    }

    It 'Creates an empty string with the Empty switch' {
        New-EldAtString -Empty | Should -BeExactly ''
    }

    It 'Creates an AT String with only the reset modifier' {
        New-EldAtString -ModReset | Should -BeExactly "`e[0m"
    }

    It 'Creates an AT String with only user data (Hello World)' {
        New-EldAtString -UserData 'Hello World' | Should -BeExactly 'Hello World'
    }

    It 'Creates an AT String with only full AT Prefix modifiers' {
        [Hashtable]$Mods = @{
            Fg24 = @{ ArrData = @(255, 255, 255) }
            Bg24 = @{ ArrData = @(255, 255, 255) }
            Deco = @{ Blink = $true }
            Coords = @{ Row = 5; Column = 5 }
            Empty = $false
        }

        New-EldAtString -Prefix $Mods | Should -BeExactly "`e[38;2;255;255;255m`e[48;2;255;255;255m`e[5m`e[5;5H"
    }

    It 'Creates a full string with mods, user data, and reset modifier' {
        [Hashtable]$Vals = @{
            Prefix = @{
                Fg24 = @{ ArrData = @(255, 255, 255) }
                Bg24 = @{ ArrData = @(255, 255, 255) }
                Deco = @{ Blink = $true }
                Coords = @{ Row = 5; Column = 5 }
                Empty = $false
            }
            UserData = 'Hello World'
            ModReset = $true
        }

        New-EldAtString @Vals | Should -BeExactly "`e[38;2;255;255;255m`e[48;2;255;255;255m`e[5m`e[5;5HHello World`e[0m"
    }

    AfterAll {
        Remove-EldVars
    }
}

Describe 'New-EldAtStrComposite' {
    BeforeAll {
        . "$PSScriptRoot\..\Private\Ansi.ps1" ; Initialize-EldVars
    }

    It 'Creates an empty string with no options supplied' {
        New-EldAtStrComposite | Should -BeExactly ''
    }

    It 'Creates a single AT String' {
        [Hashtable[]]$ATStrings = @(
            @{
                Prefix = @{
                    Fg24 = @{ ArrData = @(255, 255, 255) }
                    Bg24 = @{ ArrData = @(255, 255, 255) }
                    Deco = @{ Blink = $true }
                    Coords = @{ Row = 5; Column = 5 }
                    Empty = $false
                }
                UserData = 'Hello World'
                ModReset = $true
            }
        )

        New-EldAtStrComposite -AtStrings $ATStrings | Should -BeExactly "`e[38;2;255;255;255m`e[48;2;255;255;255m`e[5m`e[5;5HHello World`e[0m"
    }

    It 'Creates a composition of two AT Strings' {
        [Hashtable]$Vals = @{
            AtStrings = @(
                @{
                    Prefix = @{
                        Fg24 = @{ ArrData = @(255, 255, 255) }
                        Bg24 = @{ ArrData = @(255, 255, 255) }
                        Deco = @{ Blink = $true }
                        Coords = @{ Row = 5; Column = 5 }
                        Empty = $false
                    }
                    UserData = 'Hello World'
                    ModReset = $true
                },
                @{
                    Prefix = @{
                        Fg24 = @{ ArrData = @(255, 255, 255) }
                        Bg24 = @{ ArrData = @(255, 255, 255) }
                        Deco = @{ Blink = $true }
                        Coords = @{ Row = 5; Column = 5 }
                        Empty = $false
                    }
                    UserData = 'Hello World'
                    ModReset = $true
                }
            )
        }

        New-EldAtStrComposite @Vals `
            | Should -BeExactly "`e[38;2;255;255;255m`e[48;2;255;255;255m`e[5m`e[5;5HHello World`e[0m`e[38;2;255;255;255m`e[48;2;255;255;255m`e[5m`e[5;5HHello World`e[0m"
    }

    AfterAll {
        Remove-EldVars
    }
}

Describe 'New-EldAtSiString' {
    BeforeAll {
        . "$PSScriptRoot\..\Private\Ansi.ps1" ; Initialize-EldVars
    }

    It 'Creates a basic AT SI string with 1,1 coordinates, a single whitespace, and a reset modifier' {
        New-EldAtSiString | Should -BeExactly "`e[1;1H `e[0m"
    }

    It 'Creates an AT SI string with 1, 1 coordinates, background color of blue (CCBlue24), a single whitespace, and a reset modifier' {
        [Hashtable]$Vals = @{
            Bg24 = @{
                PSVData = (Get-EldVar -Name 'CCBlue24')
            }
        }

        New-EldAtSiString @Vals | Should -BeExactly "`e[48;2;0;0;255m`e[1;1H `e[0m"
    }

    It 'Creates an AT SI string with 5, 5 coordinates, background color of blue (CCBlue24), a single whitespace, and a reset modifier' {
        [Hashtable]$Vals = @{
            Bg24 = @{
                PSVData = (Get-EldVar -Name 'CCBlue24')
            }
            Coords = @{ Row = 5; Column = 5 }
        }

        New-EldAtSiString @Vals | Should -BeExactly "`e[48;2;0;0;255m`e[5;5H `e[0m"
    }

    AfterAll {
        Remove-EldVars
    }
}