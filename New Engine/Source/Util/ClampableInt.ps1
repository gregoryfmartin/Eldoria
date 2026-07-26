using namespace System

Set-StrictMode -Version Latest





###############################################################################
#
# CLAMPABLE INT
#
# CLAMPS THAT INT, GURL!
#
###############################################################################

Class ClampableInt : IComparable {
    [Int]$Value
    [Int]$Floor
    [Int]$Ceiling
    
    ClampableInt() {
        $this.Value = 0
        $this.Floor = 0
        $this.Ceiling = 0
    }
    
    ClampableInt(
        [Int]$Value,
        [Int]$Floor,
        [Int]$Ceiling
    ) {
        $this.Value = $Value
        $this.Floor = $Floor
        $this.Ceiling = ($Ceiling -LE $Floor) ? ($Floor + 1) : $Ceiling
    }
    
    [Void]SetValue(
        [Int]$Value
    ) {
        $this.Value = [Math]::Clamp($this.Value, $this.Floor, $this.Ceiling)
    }

    [Boolean]Equals(
        [Object]$Other
    ) {
        If($null -EQ $Other -OR ($Other.GetType() -NE $this.GetType())) {
            Return $false
        }

        Return ($this.Value -EQ ($Other -AS [ClampableInt]).Value)
    }

    [Int]GetHashCode() {
        Return (
            $this.Value.GetHashCode() -BXOR
            $this.Floor.GetHashCode() -BXOR
            $this.Ceiling.GetHashCode()
        )
    }

    [Int]CompareTo(
        [Object]$Other
    ) {
        If($null -EQ $Other) {
            Return 1
        }

        If($Other -IS [ClampableInt]) {
            Return $this.Value.CompareTo(($Other -AS [ClampableInt]).Value)
        }

        Return $this.Value.CompareTo(($Other -AS [Int]))
    }
    
    Hidden Static [ClampableInt]op_Addition(
        [ClampableInt]$Left,
        [ClampableInt]$Right
    ) {
        Return [ClampableInt]::new(
            [Math]::Clamp(($Left.Value + $Right.Value), $Left.Floor, $Left.Ceiling),
            $Left.Floor,
            $Left.Ceiling
        )
    }

    Hidden Static [ClampableInt]op_Addition(
        [ClampableInt]$Left,
        [Int]$Right
    ) {
        Return [ClampableInt]::new(
            [Math]::Clamp(($Left.Value + $Right), $Left.Floor, $Left.Ceiling),
            $Left.Floor,
            $Left.Ceiling
        )
    }

    Hidden Static [ClampableInt]op_Addition(
        [ClampableInt]$Left,
        [String]$Right
    ) {
        Return [ClampableInt]::new(
            [Math]::Clamp(($Left.Value + [Int]::Parse($Right)), $Left.Floor, $Left.Ceiling),
            $Left.Floor,
            $Left.Ceiling
        )
    }
    
    Hidden Static [ClampableInt]op_Subtraction(
        [ClampableInt]$Left,
        [ClampableInt]$Right
    ) {
        Return [ClampableInt]::new(
            [Math]::Clamp(($Left.Value - $Right.Value), $Left.Floor, $Left.Ceiling),
            $Left.Floor,
            $Left.Ceiling
        )
    }
    
    Hidden Static [ClampableInt]op_Multiply(
        [ClampableInt]$Left,
        [ClampableInt]$Right
    ) {
        Return [ClampableInt]::new(
            [Math]::Clamp(($Left.Value * $Right.Value), $Left.Floor, $Left.Ceiling),
            $Left.Floor,
            $Left.Ceiling
        )
    }
    
    Hidden Static [ClampableInt]op_Division(
        [ClampableInt]$Left,
        [ClampableInt]$Right
    ) {
        Return [ClampableInt]::new(
            [Math]::Clamp(($Left.Value / $Right.Value), $Left.Floor, $Left.Ceiling),
            $Left.Floor,
            $Left.Ceiling
        )
    }

    Hidden Static [Int]op_Implicit(
        [ClampableInt]$Value
    ) {
        Return $Value.Value
    }
}
