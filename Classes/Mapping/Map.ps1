using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# MAP
#
###############################################################################

Class Map {
    [Int]$MapWidth
    [Int]$MapHeight
    [String]$Name
    [Boolean]$BoundaryWrap
    [MapTile[,]]$Tiles

    Map() {
        $this.MapWidth     = 0
        $this.MapHeight    = 0
        $this.Name         = ''
        $this.BoundaryWrap = $false

        # THIS LINE PRESENTS A PROBLEM WITH SPLATTING SINCE IT EVIDENTLY GETS CALLED BEFORE
        # ANY OF THE SPLATTED VALUES ARE APPLIED TO THE OBJECT.
        $this.Tiles        = New-Object 'MapTile[,]' $this.MapHeight, $this.MapWidth
    }

    Map(
        [String]$Name,
        [Int]$MapWidth,
        [Int]$MapHeight,
        [Boolean]$BoundaryWrap
    ) {
        $this.Name         = $Name
        $this.MapWidth     = $MapWidth
        $this.MapHeight    = $MapHeight
        $this.BoundaryWrap = $BoundaryWrap
        $this.Tiles        = New-Object 'MapTile[,]' $this.MapHeight, $this.MapWidth
    }

    Map(
        [String]$JsonConfigPath
    ) {
        [Hashtable]$JsonData = @{}

        If($(Test-Path $JsonConfigPath) -EQ $true) {
            $JsonData = Get-Content -Raw $JsonConfigPath | ConvertFrom-Json -AsHashtable
        }

        $this.Name         = $JsonData['MapName']
        $this.MapWidth     = $JsonData['MapWidth']
        $this.MapHeight    = $JsonData['MapHeight']
        $this.BoundaryWrap = $JsonData['BoundaryWrap']
        $this.Tiles        = New-Object 'MapTile[,]' $this.MapHeight, $this.MapWidth

        For([Int]$Y = 0; $Y -LT $this.MapHeight; $Y++) {
            For([Int]$X = 0; $X -LT $this.MapWidth; $X++) {
                # [Hashtable]$A = $JsonData['Tiles'][$Y][$X]
                $this.Tiles[$Y, $X] = [MapTile]::new($JsonData['Tiles'][$Y][$X])
            }
        }
    }

    [Void]CreateMapTiles() {
        If($this.MapWidth -GT 0 -AND $this.MapHeight -GT 0) {
            $this.Tiles = New-Object 'MapTile[,]' $this.MapHeight, $this.MapWidth
        }
    }

    [MapTile]GetTileAtPlayerCoordinates() {
        Return $this.Tiles[$Script:ThePlayer.MapCoordinates.Row, $Script:ThePlayer.MapCoordinates.Column]
    }
}
