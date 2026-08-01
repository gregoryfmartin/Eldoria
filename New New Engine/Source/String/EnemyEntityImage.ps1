using namespace System

Set-StrictMode -Version Latest





###############################################################################
#
# ENEMY ENTITY IMAGE
#
# A COMPOSITION OF AT SCENE IMAGE STRING INTENDED TO BE USED WITH AN ENEMY
# ENTITY. THIS ISN'T AN "IMAGE" PER-SE, RATHER A LARGE ARRAY OF ANSI
# TERMINATED STRINGS THAT COALESCE INTO AN IMAGE.
#
# DUE TO THE MODULE-IZATION, THE STATIC MEMBER HAS BEEN MADE REGULAR MEMBERS.
#
###############################################################################

Class EnemyEntityImage {
    [Int]$Width
    [Int]$Height
    [ATSceneImageString[,]]$Image

    EnemyEntityImage() {
        $this.Width  = 37
        $this.Height = 15
        $this.Image  = New-Object 'ATSceneImageString[,]' ([Int32]$this.Height), ([Int32]$this.Width)
    }

    [Void]CreateImageATString(
        [ATBackgroundColor24[]]$ImageColorMap
    ) {
        For($Row = 0; $Row -LT $this.Height; $Row++) {
            For($Column = 0; $Column -LT $this.Width; $Column++) {
                $RowFlattened = ($Row * $this.Width) + $Column
                
                # THE VALUES HERE HAVE BEEN CHANGED SINCE BEING MODULARIZED
                # THEY WERE ORIGINALLY PULLED FROM STATIC MEMBERS IN THE BATTLE ENEMY IMAGE WINDOW CLASS,
                # BUT IT'S NOT POSSIBLE TO LOAD THAT CLASS BEFORE THIS ONE, SO THE VALUES HAVE
                # BEEN PRECOMPUTED AND PLACED IN THE EQUATION INSTEAD.
                $this.Image[$Row, $Column] = [ATSceneImageString]::new(
                    $ImageColorMap[$RowFlattened],
                    [ATCoordinates]::new((2 + $Row), (44 + $Column))
                )
            }
        }
    }

    [String]ToAnsiControlSequenceString() {
        [String]$Composite = ''

        For($Row = 0; $Row -LT $this.Height; $Row++) {
            For($Column = 0; $Column -LT $this.Width; $Column++) {
                $Composite += "$($this.Image[$Row, $Column].ToAnsiControlSequenceString())"
            }
        }

        Return "$($Composite)"
    }
}
