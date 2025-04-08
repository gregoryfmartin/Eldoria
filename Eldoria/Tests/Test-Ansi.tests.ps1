Describe 'New-EldFg24String' {
    BeforeAll {
        . "$PSScriptRoot\..\Private\Ansi.ps1"
        
        Initialize-EldVars
    }

    It 'Produces a properly formatted ANSI SGR string with the default values' {
        [String]$Test = New-EldFg24String

        $Test | Should -BeExactly "`e[38;2;0;0;0m"
    }

    It 'Produces a properly formatted ANSI SGR string with a custom color (white)' {
        [String]$Test = New-EldFg24String -ColorData @(255, 255, 255)

        $Test | Should -BeExactly "`e[38;2;255;255;255m"
    }

    It 'Produces an empty string when asked' {
        [String]$Test = New-EldFg24String -Empty

        $Test | Should -BeExactly ''
    }

    It 'Throws an exception if ColorData isn''t the proper length (3)' {
        Try {
            $null = New-EldFg24String -ColorData @(0, 0) | Should -Throw
        } Catch {}
    }

    It 'Throws an exception if any of the Channel Values are out of range (0-255)' {
        Try {
            $null = New-EldFg24String -ColorData @(0, 0, -1) | Should -Throw
        } Catch {}
    }

    It 'Writes an error if AnsiFgCol24Prefix isn''t set' {
        Remove-Variable -Name 'ELD:AnsiFgCol24Prefix' -Scope Global -Force

        Try {
            $null = New-EldFg24String | Should -Throw
        } Catch {}
    }

    AfterAll {
        Remove-EldVars
        Write-Host "`e[m"
    }
}

Describe 'New-EldBg24String' {
    BeforeAll {
        . "$PSScriptRoot\..\Private\Ansi.ps1"
        
        Initialize-EldVars
    }

    It 'Produces a properly formatted ANSI SGR string with the default values' {
        [String]$Test = New-EldBg24String

        $Test | Should -BeExactly "`e[48;2;0;0;0m"
    }

    It 'Produces a properly formatted ANSI SGR string with a custom color (white)' {
        [String]$Test = New-EldBg24String -ColorData @(255, 255, 255)

        $Test | Should -BeExactly "`e[48;2;255;255;255m"
    }

    It 'Produces an empty string when asked' {
        [String]$Test = New-EldBg24String -Empty

        $Test | Should -BeExactly ''
    }

    It 'Throws an exception if ColorData isn''t the proper length (3)' {
        Try {
            $null = New-EldBg24String -ColorData @(0, 0) | Should -Throw
        } Catch {}
    }

    It 'Throws an exception if any of the Channel Values are out of range (0-255)' {
        Try {
            $null = New-EldBg24String -ColorData @(0, 0, -1) | Should -Throw
        } Catch {}
    }

    It 'Writes an error if AnsiBgCol24Prefix isn''t set' {
        Remove-Variable -Name 'ELD:AnsiBgCol24Prefix' -Scope Global -Force

        Try {
            $null = New-EldBg24String | Should -Throw
        } Catch {}
    }

    AfterAll {
        Remove-EldVars
        Write-Host "`e[m"
    }
}

Describe 'New-EldCoordString' {
    BeforeAll {
        . "$PSScriptRoot\..\Private\Ansi.ps1"
        
        Initialize-EldVars
    }

    It 'Should produce a string with 1,1 as coordinates (default)' {
        [String]$Test = New-EldCoordString

        $Test | Should -BeExactly "`e[1;1H"
    }

    It 'Should produce a string with custom coordinates (5,5)' {
        [String]$Test = New-EldCoordString -Row 5 -Column 5

        $Test | Should -BeExactly "`e[5;5H"
    }

    It 'Should produce an empty string when asked' {
        [String]$Test = New-EldCoordString -Empty

        $Test | Should -BeExactly ''
    }

    It 'Should throw an exception if Row or Column are out of range (1-80)' {
        Try {
            $null = New-EldCoordString -Row -10 -Column 500 | Should -Throw
        } Catch {}
    }

    AfterAll {
        Remove-EldVars
        Write-Host "`e[m"
    }
}