using namespace System

Set-StrictMode -Version Latest





BeforeAll {
    . "$($PSScriptRoot)/../Util/ClampableInt.ps1"
}





Context 'Addition Operator Overload' {
    It 'Adds two ClampableInt instances together' {
        [ClampableInt]$A = [ClampableInt]::new(5, 5, 10)
        [ClampableInt]$B = [ClampableInt]::new(5, 5, 10)

        ($A + $B).Value | Should -Be 10
    }

    It 'Adds an integer to a ClampableInt' {
        [ClampableInt]$A = [ClampableInt]::new(5, 5, 10)
        [Int]$B = 15

        ($A + $B).Value | Should -Be 10
    }

    It 'Adds a number in a string to a ClampableInt' {
        [ClampableInt]$A = [ClampableInt]::new(5, 5, 10)
        [String]$B = '15'

        ($A + $B).Value | Should -Be 10
    }
}

Context 'Subtraction Operator Overload' {
    It 'Subtracts two ClampableInt instances' {
        [ClampableInt]$A = [ClampableInt]::new(5, 0, 10)
        [ClampableInt]$B = [ClampableInt]::new(5, 5, 10)

        ($A - $B).Value | Should -Be 0
    }
}

Context 'Multiplication Operator Overload' {
    It 'Multiplies two ClampableInt instances' {
        [ClampableInt]$A = [ClampableInt]::new(5, 5, 10)
        [ClampableInt]$B = [ClampableInt]::new(2, 5, 10)

        ($A * $B).Value | Should -Be 10
    }
}

Context 'Division Operator Overload' {
    It 'Divides two ClampableInt instances' {
        [ClampableInt]$A = [ClampableInt]::new(10, 5, 10)
        [ClampableInt]$B = [ClampableInt]::new(2, 5, 10)

        ($A / $B).Value | Should -Be 5
    }
}
