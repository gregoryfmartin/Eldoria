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
# RELIES ON:
#   ATSCENEIMAGESTRING
#   ATCOORDINATES
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

    [Void]CreateImageATString([ATBackgroundColor24[]]$ImageColorMap) {
        For($r = 0; $r -LT $this.Height; $r++) {
            For($c = 0; $c -LT $this.Width; $c++) {
                $rf = ($r * $this.Width) + $c
                
                # THE VALUES HERE HAVE BEEN CHANGED SINCE BEING MODULARIZED
                # THEY WERE ORIGINALLY PULLED FROM STATIC MEMBERS IN THE BATTLE ENEMY IMAGE WINDOW CLASS,
                # BUT IT'S NOT POSSIBLE TO LOAD THAT CLASS BEFORE THIS ONE, SO THE VALUES HAVE
                # BEEN PRECOMPUTED AND PLACED IN THE EQUATION INSTEAD.
                $this.Image[$r, $c] = [ATSceneImageString]::new(
                    $ImageColorMap[$rf],
                    [ATCoordinates]::new((2 + $r), (44 + $c))
                )
            }
        }
    }

    [String]ToAnsiControlSequenceString() {
        [String]$a = ''

        For($r = 0; $r -LT $this.Height; $r++) {
            For($c = 0; $c -LT $this.Width; $c++) {
                $a += $this.Image[$r, $c].ToAnsiControlSequenceString()
            }
        }

        Return $a
    }
}
