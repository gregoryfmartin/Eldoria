using namespace System

Set-StrictMode -Version Latest





###############################################################################
#
# SI RANDOM NOISE
#
# A SPECIALIZATION OF SCENE IMAGE THAT GENERATES RANDOM NOISE PER CELL.
#
###############################################################################

Class SIRandomNoise : SceneImage {
    [ATBackgroundColor24[]]$ColorMap

    SIRandomNoise() : base() {
        $this.ColorMap = New-Object 'ATBackgroundColor24[]' ([Int32](([Int32]([SceneImage]::Width)) * ([Int32]([SceneImage]::Height))))

        For($Color = 0; $Color -LT $this.ColorMap.Count; $Color++) {
            $this.ColorMap[$Color] = [ColorLibrary]::Random
        }
        $this.CreateSceneImageATString($this.ColorMap)
        $this.ColorMap = $null
    }
}
