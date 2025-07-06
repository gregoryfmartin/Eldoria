using namespace System

Set-StrictMode -Version Latest

#//////////////////////////////////////////////////////////////////////////////
#
# SCENE IMAGE
#
# DEFINES AN "IMAGE" THAT'S SHOWN ON THE NAVIGATION SCREEN. THIS LOOKS A LOT
# LIKE AN ENEMY IMAGE, JUST WITH DIFFERENT DIMENSIONS. SPECIALIZATIONS OF THIS
# ARE CREATED USING A SIMILAR PATTERN AS WELL.
#
# DUE TO THE MODULE-IZATION, THE STATIC MEMBER HAS BEEN MADE REGULAR MEMBERS.
#
#//////////////////////////////////////////////////////////////////////////////
Class SceneImage {
    [Int]$Width
    [Int]$Height
    [ATSceneImageString[,]]$Image

    SceneImage() {
        $this.Width  = 48
        $this.Height = 18
        $this.Image  = New-Object 'ATSceneImageString[,]' ([Int32]$this.Height), ([Int32]$this.Width)
    }

    SceneImage(
        [ATSceneImageString[,]]$Image
    ) {
        $this.Width  = 48
        $this.Height = 18
        $this.Image  = $Image
    }

    [Void]CreateSceneImageATString([ATBackgroundColor24[]]$ImageColorMap) {
        For($r = 0; $r -LT $this.Height; $r++) {
            For($c = 0; $c -LT $this.Width; $c++) {
                $rf = ($r * $this.Width) + $c
                
                # THE VALUES HERE HAVE BEEN CHANGED SINCE BEING MODULARIZED
                # THEY WERE ORIGINALLY PULLED FROM STATIC MEMBERS IN THE SCENE WINDOW CLASS,
                # BUT IT'S NOT POSSIBLE TO LOAD THAT CLASS BEFORE THIS ONE, SO THE VALUES HAVE
                # BEEN PRECOMPUTED AND PLACED IN THE EQUATION INSTEAD.
                $this.Image[$r, $c] = [ATSceneImageString]::new(
                    $ImageColorMap[$rf],
                    [ATCoordinates]::new((2 + $r), (31 + $c))
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
