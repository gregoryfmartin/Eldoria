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
###############################################################################
Class EnemyEntityImage {
    Static [Int]$Width  = 37
    Static [Int]$Height = 15

    [ATSceneImageString[,]]$Image

    EnemyEntityImage() {
        $this.Image = New-Object 'ATSceneImageString[,]' ([Int32]([SceneImage]::Height)), ([Int32]([SceneImage]::Width))
    }

    [Void]CreateImageATString([ATBackgroundColor24[]]$ImageColorMap) {
        For($r = 0; $r -LT [EnemyEntityImage]::Height; $r++) {
            For($c = 0; $c -LT [EnemyEntityImage]::Width; $c++) {
                $rf                 = ($r * [EnemyEntityImage]::Width) + $c
                $this.Image[$r, $c] = [ATSceneImageString]::new(
                    $ImageColorMap[$rf],
                    [ATCoordinates]::new(([BattleEnemyImageWindow]::ImageDrawRowOffset + $r), ([BattleEnemyImageWindow]::ImageDrawColumnOffset + $c))
                )
            }
        }
    }

    [String]ToAnsiControlSequenceString() {
        [String]$a = ''

        For($r = 0; $r -LT [EnemyEntityImage]::Height; $r++) {
            For($c = 0; $c -LT [EnemyEntityImage]::Width; $c++) {
                $a += $this.Image[$r, $c].ToAnsiControlSequenceString()
            }
        }

        Return $a
    }
}
