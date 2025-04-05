Describe 'Set-EldVar' {
    BeforeAll {
        . "$PSScriptRoot\..\Private\Vars.ps1"
    }

    It 'Should create a variable in the global scope with the ELD: prefix' {
        Set-EldVar -Name 'TestVar' -Value 0

        $Result = Get-Variable -Name 'ELD:TestVar' -Scope Global

        $Result.Value | Should -Be 0

        Remove-Variable -Name 'ELD:TestVar' -Scope Global -Force
    }

    It 'Should create a variable with the ReadOnly option when asked' {
        Set-EldVar -Name 'TestVar' -Value 0 -ReadOnly

        $Result = Get-Variable -Name 'ELD:TestVar' -Scope Global

        $Result.Options -BAND [System.Management.Automation.ScopedItemOptions]::ReadOnly | Should -Be $true

        Remove-Variable -Name 'ELD:TestVar' -Scope Global -Force
    }
}

Describe 'Remove-EldVars' {
    BeforeAll {
        . "$PSScriptRoot\..\Private\Vars.ps1"
    }

    It 'Should remove all variables from the global scope with the ELD: prefix' {
        Set-EldVar -Name 'TestVar' -Value 0
        Remove-EldVars

        $Result = Get-Variable -Name 'ELD:TestVar' -Scope Global -ErrorAction SilentlyContinue
        $Result | Should -BeNullOrEmpty
    }
}

Describe 'Get-EldVar' {
    BeforeAll {
        . "$PSScriptRoot\..\Private\Vars.ps1"
    }

    It 'Should retreive the value of ELD:TestVar, which should be zero' {
        Set-EldVar -Name 'TestVar' -Value 0

        $Result = Get-Variable -Name 'ELD:TestVar' -Scope Global -ErrorAction SilentlyContinue
        $Result.Value | Should -Be 0

        Remove-Variable -Name 'ELD:TestVar' -Scope Global -Force
    }
}