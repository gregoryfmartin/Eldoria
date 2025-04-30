Describe 'New-EldVar' {
    BeforeAll {
        . "$PSScriptRoot\..\Private\Vars.ps1"
    }

    It 'Creates a variable in the global scope with the prefix ELD:' {
        New-EldVar -Name 'Sample' -Data 0

        $Result = Get-Variable -Name 'ELD:Sample' -Scope Global -ErrorAction SilentlyContinue
        $Result | Should -BeOfType [PSVariable]
        $Result.Value | Should -BeExactly 0

        Remove-Variable -Name 'ELD:Sample' -Scope Global -Force
    }

    It 'Creates a read-only variable in the global scope with the prefix ELD:' {
        New-EldVar -Name 'Sample' -Data 0 -ReadOnly

        $Result = Get-Variable -Name 'ELD:Sample' -Scope Global -ErrorAction SilentlyContinue
        $Result | Should -BeOfType [PSVariable]
        $Result.Value | Should -BeExactly 0
        $Result.Options -BAND [System.Management.Automation.ScopedItemOptions]::ReadOnly | Should -Be $true

        Remove-Variable -Name 'ELD:Sample' -Scope Global -Force
    }

    It 'Throws an Exception if the value for Name isn''t specified' {
        Try {
            New-EldVar -Data 0 | Should -Throw
        } Catch {}
    }

    It 'Sets the value of a new variable to null if the Data parameter is omitted' {
        New-EldVar -Name 'Dave'

        $Result = Get-Variable -Name 'ELD:Dave' -Scope Global -ErrorAction SilentlyContinue
        $Result.Value | Should -BeNullOrEmpty

        Remove-Variable -Name 'ELD:Dave' -Scope Global -Force
    }
}

Describe 'Assert-EldVarExists' {
    BeforeAll {
        . "$PSScriptRoot\..\Private\Vars.ps1"
    }

    It 'Doesn''t throw an Expcetion if a global variable with the ELD prefix exists' {
        New-EldVar -Name 'Sample'

        { Assert-EldVarExists -Name 'Sample' } | Should -Not -Throw

        Remove-Variable -Name 'ELD:Sample' -Scope Global -Force
    }

    It 'Throws an Exception if a global variable with the ELD prefix doesn''t exist' {
        { Assert-EldVar -Name 'Sample' } | Should -Throw
    }
}

Describe 'Get-EldVar' {
    BeforeAll {
        . "$PSScriptRoot\..\Private\Vars.ps1"
    }

    It 'Obtains the requested ELD variable if it exists' {
        New-EldVar -Name 'Sample'

        $Result = Get-EldVar -Name 'Sample'
        $Result | Should -BeOfType [PSVariable]
        $Result.Value | Should -BeNullOrEmpty

        Remove-Variable -Name 'ELD:Sample' -Scope Global -Force
    }

    It 'Should throw an Exception if the requested ELD variable doesn''t exist.' {
        { $null = Get-EldVar -Name 'Sample' } | Should -Throw
    }
}

Describe 'Assert-EldVarReadOnly' {
    BeforeAll {
        . "$PSScriptRoot\..\Private\Vars.ps1"
    }

    It 'Throws an Exception if a specified ELD variable is readonly.' {
        New-EldVar -Name 'Sample' -ReadOnly

        { Assert-EldVarReadOnly -Name 'Sample' } | Should -Throw

        Remove-Variable -Name 'ELD:Sample' -Scope Global -Force
    }

    It 'Doesn''t throw an Exception if a specified ELD variable is not readonly.' {
        New-EldVar -Name 'Sample'

        { Assert-EldVarReadOnly -Name 'Sample' } | Should -Not -Throw

        Remove-Variable -Name 'ELD:Sample' -Scope Global -Force
    }
}

Describe 'Set-EldVar' {
    BeforeAll {
        . "$PSScriptRoot\..\Private\Vars.ps1"
    }

    It 'Changes the value of an existing ELD variable from 0 to 1' {
        New-EldVar -Name 'Sample' -Data 0
        Set-EldVar -Name 'Sample' -Data 1

        $Result = Get-EldVar -Name 'Sample'
        $Result | Should -BeOfType [PSVariable]
        $Result.Value | Should -BeExactly 1

        Remove-Variable -Name 'ELD:Sample' -Scope Global -Force
    }
}

Describe 'Initialize-EldVars' {
    BeforeAll {
        . "$PSScriptRoot\..\Private\Vars.ps1"
    }

    It 'Creates all ELD variables needed in the global scope' {
        Initialize-EldVars
    }

    It 'Creates an ELD variable named CCAppleVPurpleDark24' {     
        $Result = Get-EldVar -Name 'CCAppleVPurpleDark24'
        $Result | Should -BeOfType [PSVariable]
        $Result.Value | Should -BeExactly @(204, 101, 255)
    }

    AfterAll {
        Remove-EldVars
    }
}

Describe 'Remove-EldVars' {
    BeforeAll {
        . "$PSScriptRoot\..\Private\Vars.ps1"
    }

    It 'Removes all ELD variables from the global scope' {
        Initialize-EldVars
        Remove-EldVars

        Get-ChildItem Variable: | Where-Object { $_.Name -LIKE 'ELD:*' } | Should -BeNullOrEmpty
    }

    AfterAll {
        Remove-EldVars
    }
}