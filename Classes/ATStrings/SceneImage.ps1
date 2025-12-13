using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# SCENE IMAGE
#
# DEFINES AN "IMAGE" THAT'S SHOWN ON THE NAVIGATION SCREEN. THIS LOOKS A LOT
# LIKE AN ENEMY IMAGE, JUST WITH DIFFERENT DIMENSIONS. SPECIALIZATIONS OF THIS
# ARE CREATED USING A SIMILAR PATTERN AS WELL.
#
# DUE TO THE MODULE-IZATION, THE STATIC MEMBER HAS BEEN MADE REGULAR MEMBERS.
#
# RELIES ON:
#   ATSCENEIMAGESTRING
#   ATCOORDINATES
#
###############################################################################

Class SceneImage {
    Static [Int]$Width  = 48
    Static [Int]$Height = 18

    #[Int]$LWidth
    #[Int]$LHeight
    [ATSceneImageString[,]]$Image

    SceneImage() {
        [Int]$LWidth  = [SceneImage]::Width
        [Int]$LHeight = [SceneImage]::Height
        $this.Image  = New-Object 'ATSceneImageString[,]' ([Int32]([SceneImage]::Height)), ([Int32]([SceneImage]::Width))
    }

    SceneImage(
        [ATSceneImageString[,]]$Image
    ) {
        #$this.LWidth  = [SceneImage]::Width
        #$this.LHeight = [SceneImage]::Height
        $this.Image  = $Image
    }

    [Void]CreateSceneImageATString([ATBackgroundColor24[]]$ImageColorMap) {
        For($r = 0; $r -LT [SceneImage]::Height; $r++) {
            For($c = 0; $c -LT [SceneImage]::Width; $c++) {
                $rf = ($r * [SceneImage]::Width) + $c
                
                # THE VALUES HERE HAVE BEEN CHANGED SINCE BEING MODULARIZED
                # THEY WERE ORIGINALLY PULLED FROM STATIC MEMBERS IN THE SCENE WINDOW CLASS,
                # BUT IT'S NOT POSSIBLE TO LOAD THAT CLASS BEFORE THIS ONE, SO THE VALUES HAVE
                # BEEN PRECOMPUTED AND PLACED IN THE EQUATION INSTEAD.
                $this.Image[$r, $c] = [ATSceneImageString]::new(
                    $ImageColorMap[$rf],
                    [ATCoordinates]::new((5 + $r), (32 + $c))
                )
            }
        }
    }

    [String]ToAnsiControlSequenceString() {
        [String]$a = ''

        For($r = 0; $r -LT [SceneImage]::Height; $r++) {
            For($c = 0; $c -LT [SceneImage]::Width; $c++) {
                $a += $this.Image[$r, $c].ToAnsiControlSequenceString()
            }
        }

        Return $a
    }
}
