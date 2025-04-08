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