using namespace System
using namespace System.Collections.Generic

Set-StrictMode -Version Latest

###############################################################################
#
# MAP TILE
#
# A "PLACE" ON A MAP. ANY GIVEN COORDINATE PAIR VALUE RELATES TO A SINGLE MAP 
# TILE. MAP TILE NAVIGATION IS RESTRICTED TO CARDINAL DIRECTIONS, CONSEQUENTLY
# SOME DIRECTIONS ARE "EXITABLE" WHILE OTHERS AREN'T. MAP TILES HAVE A SINGLE
# "IMAGE" THAT IS DRAWN ON THE NAVIGATION SCREEN IN THE SCENE IMAGE WINDOW.
# MAP TILES CAN CONTAIN ZERO OR MORE MAP TILE OBJECTS THAT CAN BE INTERACTED
# WITH, EITHER BY EXAMINATION, AUGMENTATION, OR COLLECTION. EVERY MAP TILE
# OBJECT CAN BE EXAMINED, WHILE ONLY SELECT ONES CAN BE AUGMENTED OR COLLECTED.
# THIS IS DETERMINED BY A "TARGET OF" FILTER, WHICH IS DESCRIBED AT THE MAP
# TILE OBJECT DEFINITION.
#
# MAP TILES ALSO PLAY AN INTEGRAL PART OF THE COMBAT SYSTEM AS THEY SERVE AS 
# THE ENTRY POINT FOR THE COMBAT SUB-PROGRAM. THIS IS FACILITATED BY HAVING
# EACH TILE SPECIFIY THE FOLLOWING: IS BATTLE ALLOWED ON THIS TILE, WHAT IS
# THE EFFECTIVE ENCOUNTER RATE (OR CHANCE OF ENTERING A COMBAT SITUATION; THIS
# IS DETERMINED WHEN THE TILE IS CREATED AND DOESN'T CHANGE OVER TIME; IT 
# PROBABLY SHOULD! :)), AND A "REGION CODE" WHICH MAPS TO A HASHTABLE THAT
# CONTAINS ARRAYS THAT MAP TO REGION CODES. THESE ARRAYS SPECIFY WHICH KINDS OF
# ENEMIES CAN BE ENCOUNTERED IN THIS REGION.
#
###############################################################################

Class MapTile {
    [Int]$TileExitNorth
    [Int]$TileExitSouth
    [Int]$TileExitEast
    [Int]$TileExitWest
    [SceneImage]$BackgroundImage
    [List[MapTileObject]]$ObjectListing
    [Boolean[]]$Exits
    [Boolean]$BattleAllowed
    [Double]$EncounterRate
    [Int]$RegionCode

    MapTile() {
        $this.TileExitNorth   = 0
        $this.TileExitSouth   = 1
        $this.TileExitEast    = 2
        $this.TileExitWest    = 3
        $this.BackgroundImage = [SIEmpty]::new()
        $this.ObjectListing   = [List[MapTileObject]]::new()
        $this.Exits = @(
            $false,
            $false,
            $false,
            $false
        )
        $this.BattleAllowed = $false
        $this.EncounterRate = 0.5
        $this.RegionCode    = 0
    }

    MapTile(
        [SceneImage]$BackgroundImage,
        [MapTileObject[]]$ObjectListing,
        [Boolean[]]$Exits
    ) {
        $this.TileExitNorth   = 0
        $this.TileExitSouth   = 1
        $this.TileExitEast    = 2
        $this.TileExitWest    = 3
        $this.BackgroundImage = $BackgroundImage
        $this.ObjectListing   = [List[MapTileObject]]::new()
        $this.Exits           = $Exits
        $this.BattleAllowed   = $false
        $this.EncounterRate   = 0.5
        $this.RegionCode      = 0

        Foreach($a In $ObjectListing) {
            $this.ObjectListing.Add($a) | Out-Null
        }
    }

    MapTile(
        [SceneImage]$BackgroundImage,
        [MapTileObject[]]$ObjectListing,
        [Boolean[]]$Exits,
        [Boolean]$BattleAllowed,
        [Double]$EncounterRate,
        [Int]$RegionCode
    ) {
        $this.TileExitNorth   = 0
        $this.TileExitSouth   = 1
        $this.TileExitEast    = 2
        $this.TileExitWest    = 3
        $this.BackgroundImage = $BackgroundImage
        $this.ObjectListing   = [List[MapTileObject]]::new()
        $this.Exits           = $Exits
        $this.BattleAllowed   = $BattleAllowed
        $this.EncounterRate   = $EncounterRate
        $this.RegionCode      = $RegionCode

        Foreach($a in $ObjectListing) {
            $this.ObjectListing.Add($a) | Out-Null
        }
    }

    MapTile(
        [Hashtable]$JsonData
    ) {
        $this.TileExitNorth   = 0
        $this.TileExitSouth   = 1
        $this.TileExitEast    = 2
        $this.TileExitWest    = 3
        $this.BackgroundImage = $Script:TheSceneImages[$JsonData['BackgroundImage']]
        $this.Exits           = $JsonData['Exits']
        $this.BattleAllowed   = $JsonData['BattleAllowed']
        $this.EncounterRate   = $JsonData['EncounterRate']
        $this.RegionCode      = $JsonData['RegionCode']
        $this.ObjectListing   = [List[MapTileObject]]::new()

        Foreach($A in $JsonData['ObjectListing']) {
            $this.ObjectListing.Add($(New-Object -TypeName $A)) | Out-Null
        }
    }

    [Boolean]IsItemInTile([String]$ItemName) {
        Foreach($a in $this.ObjectListing) {
            If($a.Name -IEQ $ItemName) {
                Return $true
            }
        }

        Return $false
    }

    [MapTileObject]GetItemReference([String]$ItemName) {
        Foreach($a in $this.ObjectListing) {
            If($a.Name -IEQ $ItemName) {
                Return $a
            }
        }

        Return $null
    }

    [Void]BattleStep() {
        # THIS IS LIKELY GOING TO HAVE TO BE MOVED TO A DEDICATED SCRIPT BLOCK
        If($this.BattleAllowed -EQ $true) {
            [Double]$BattleChance = Get-Random -Minimum 0.0 -Maximum 1.0
            If($BattleChance -GT $this.EncounterRate) {
                $Script:TheCurrentEnemy = New-Object -TypeName $($Script:BattleEncounterRegionTable[$this.RegionCode] | Get-Random)
                $Script:TheBufferManager.CopyActiveToBufferAWithWipe()
                $Script:ThePreviousGlobalGameState = $Script:TheGlobalGameState
                $Script:TheGlobalGameState         = [GameStatePrimary]::BattleScreen
            }
        }
    }
}
