using namespace System
using namespace System.Collections.Generic

Set-StrictMode -Version Latest

###############################################################################
#
# PLAYER
#
# A SPECIALIZATION OF BATTLE ENTITY THAT REPRESENTS THE PLAYER.
#
###############################################################################

Class Player : BattleEntity {
    Static [ConsoleColor24]$AsideColor    = [CCAppleIndigoLight24]::new()
    Static [ConsoleColor24]$GoldDrawColor = [CCAppleYellowLight24]::new()
    
    [Int]$CurrentGold
    [Int]$ProfileImageIndex

    [ATCoordinates]$MapCoordinates

    # [List[MapTileObject]]$Inventory
    [List[String]]$TargetOfFilter

    [PlayerItemInventory]$ItemInventory

    [PlayerActionInventory]$ActionInventory

    [Hashtable]$EquipmentListing

    Player() : base() {
        $this.CurrentGold       = 0
        $this.ProfileImageIndex = 0
        $this.MapCoordinates    = [ATCoordinates]::new(0, 0)
        # $this.Inventory         = [List[MapTileObject]]::new()
        $this.TargetOfFilter    = [List[String]]::new()
        $this.ItemInventory = [PlayerItemInventory]::new()
        $this.ActionInventory   = [PlayerActionInventory]::new()
        $this.EquipmentListing  = @{
            [EquipmentSlot]::Armor     = $null
            [EquipmentSlot]::Boots     = $null
            [EquipmentSlot]::Cape      = $null
            [EquipmentSlot]::Gauntlets = $null
            [EquipmentSlot]::Greaves   = $null
            [EquipmentSlot]::Helmet    = $null
            [EquipmentSlot]::JewelryA  = $null
            [EquipmentSlot]::JewelryB  = $null
            [EquipmentSlot]::Pauldron  = $null
            [EquipmentSlot]::Weapon    = $null
        }
        
        # MOCK INVENTORY ADD CODE
        $this.ItemInventory.AddItem([MTOLadder]::new(), (Get-Random -Minimum 1 -Maximum 99))
        $this.ItemInventory.AddItem([MTOApple]::new(), (Get-Random -Minimum 1 -Maximum 99))
        $this.ItemInventory.AddItem([MTOBacon]::new(), (Get-Random -Minimum 1 -Maximum 99))
        $this.ItemInventory.AddItem([MTORope]::new(), (Get-Random -Minimum 1 -Maximum 99))
        $this.ItemInventory.AddItem([MTOMilk]::new(), (Get-Random -Minimum 1 -Maximum 99))
        $this.ItemInventory.AddItem([MTOPole]::new(), (Get-Random -Minimum 1 -Maximum 99))
        $this.ItemInventory.AddItem([MTORock]::new(), (Get-Random -Minimum 1 -Maximum 99))
        $this.ItemInventory.AddItem([MTORope]::new(), (Get-Random -Minimum 1 -Maximum 99))
        $this.ItemInventory.AddItem([MTOStairs]::new(), (Get-Random -Minimum 1 -Maximum 99))
        $this.ItemInventory.AddItem([MTOStick]::new(), (Get-Random -Minimum 1 -Maximum 99))
        $this.ItemInventory.AddItem([MTOTree]::new(), (Get-Random -Minimum 1 -Maximum 99))
        $this.ItemInventory.AddItem([MTOYogurt]::new(), (Get-Random -Minimum 1 -Maximum 99))
    }

    [Void]MapMoveSouth() {
        If($Script:CurrentMap.GetTileAtPlayerCoordinates().Exits[[MapTile]::TileExitSouth] -EQ $true) {
            If($Script:CurrentMap.BoundaryWrap -EQ $true) {
                $a = $Script:CurrentMap.MapHeight - 1
                $b = $this.MapCoordinates.Row + 1
                $c = $a % $b

                If($c -EQ $a) {
                    $this.MapCoordinates.Row = 0
                } Else {
                    $this.MapCoordinates.Row++
                }
                $Script:TheSceneWindow.UpdateCurrentImage($Script:CurrentMap.GetTileAtPlayerCoordinates().BackgroundImage)
                $Script:TheCommandWindow.UpdateCommandHistory($true)
                $Script:CurrentMap.GetTileAtPlayerCoordinates().BattleStep()

                Return
            } Else {
                $a = $Script:CurrentMap.MapHeight - 1
                $b = $this.MapCoordinates.Row + 1
                $c = $a % $b

                If($c -EQ $a) {
                    $Script:TheCommandWindow.UpdateCommandHistory($true)
                    $Script:TheMessageWindow.WriteInvisibleWallEncounteredMessage()
                } Else {
                    $this.MapCoordinates.Row++
                    $Script:TheSceneWindow.UpdateCurrentImage($Script:CurrentMap.GetTileAtPlayerCoordinates().BackgroundImage)
                    $Script:TheCommandWindow.UpdateCommandHistory($true)
                    $Script:CurrentMap.GetTileAtPlayerCoordinates().BattleStep()

                    Return
                }
            }
        } Else {
            $Script:TheCommandWindow.UpdateCommandHistory($true)
            $Script:TheMessageWindow.WriteYouShallNotPassMessage()

            Return
        }
    }

    [Void]MapMoveNorth() {
        If($Script:CurrentMap.GetTileAtPlayerCoordinates().Exits[[MapTile]::TileExitNorth] -EQ $true) {
            If($Script:CurrentMap.BoundaryWrap -EQ $true) {
                $a = 0
                $b = $this.MapCoordinates.Row - 1

                If($b -LT $a) {
                    $this.MapCoordinates.Row = $Script:CurrentMap.MapHeight - 1
                } Else {
                    $this.MapCoordinates.Row--
                }
                $Script:TheSceneWindow.UpdateCurrentImage($Script:CurrentMap.GetTileAtPlayerCoordinates().BackgroundImage)
                $Script:TheCommandWindow.UpdateCommandHistory($true)
                $Script:CurrentMap.GetTileAtPlayerCoordinates().BattleStep()

                Return
            } Else {
                $a = 0
                $b = $this.MapCoordinates.Row - 1

                If($b -LT $a) {
                    $Script:TheCommandWindow.UpdateCommandHistory($true)
                    $Script:TheMessageWindow.WriteInvisibleWallEncounteredMessage()
                } Else {
                    $this.MapCoordinates.Row--
                    $Script:TheSceneWindow.UpdateCurrentImage($Script:CurrentMap.GetTileAtPlayerCoordinates().BackgroundImage)
                    $Script:TheCommandWindow.UpdateCommandHistory($true)
                    $Script:CurrentMap.GetTileAtPlayerCoordinates().BattleStep()

                    Return
                }
            }
        } Else {
            $Script:TheCommandWindow.UpdateCommandHistory($true)
            $Script:TheMessageWindow.WriteYouShallNotPassMessage()

            Return
        }
    }

    [Void]MapMoveEast() {
        If($Script:CurrentMap.GetTileAtPlayerCoordinates().Exits[[MapTile]::TileExitEast] -EQ $true) {
            If($Script:CurrentMap.BoundaryWrap -EQ $true) {
                $a = $Script:CurrentMap.MapWidth - 1
                $b = $this.MapCoordinates.Column + 1
                $c = $a % $b

                If($c -EQ $a) {
                    $this.MapCoordinates.Column = 0
                } Else {
                    $this.MapCoordinates.Column++
                }
                $Script:TheSceneWindow.UpdateCurrentImage($Script:CurrentMap.GetTileAtPlayerCoordinates().BackgroundImage)
                $Script:TheCommandWindow.UpdateCommandHistory($true)
                $Script:CurrentMap.GetTileAtPlayerCoordinates().BattleStep()

                Return
            } Else {
                $a = $Script:CurrentMap.MapWidth - 1
                $b = $this.MapCoordinates.Column + 1
                $c = $a % $b

                If($c -EQ $a) {
                    $Script:TheCommandWindow.UpdateCommandHistory($true)
                    $Script:TheMessageWindow.WriteInvisibleWallEncounteredMessage()
                } Else {
                    $this.MapCoordinates.Column++
                    $Script:TheSceneWindow.UpdateCurrentImage($Script:CurrentMap.GetTileAtPlayerCoordinates().BackgroundImage)
                    $Script:TheCommandWindow.UpdateCommandHistory($true)
                    $Script:CurrentMap.GetTileAtPlayerCoordinates().BattleStep()

                    Return
                }
            }
        } Else {
            $Script:TheCommandWindow.UpdateCommandHistory($true)
            $Script:TheMessageWindow.WriteYouShallNotPassMessage()

            Return
        }
    }

    [Void]MapMoveWest() {
        If($Script:CurrentMap.GetTileAtPlayerCoordinates().Exits[[MapTile]::TileExitWest] -EQ $true) {
            If($Script:CurrentMap.BoundaryWrap -EQ $true) {
                $a = 0
                $b = $this.MapCoordinates.Column - 1

                If($b -LT $a) {
                    $this.MapCoordinates.Column = $Script:CurrentMap.MapWidth - 1
                } Else {
                    $this.MapCoordinates.Column--
                }
                $Script:TheSceneWindow.UpdateCurrentImage($Script:CurrentMap.GetTileAtPlayerCoordinates().BackgroundImage)
                $Script:TheCommandWindow.UpdateCommandHistory($true)
                $Script:CurrentMap.GetTileAtPlayerCoordinates().BattleStep()

                Return
            } Else {
                $a = 0
                $b = $this.MapCoordinates.Column - 1

                If($b -LT $a) {
                    $Script:TheCommandWindow.UpdateCommandHistory($true)
                    $Script:TheMessageWindow.WriteInvisibleWallEncounteredMessage()
                } Else {
                    $this.MapCoordinates.Column--
                    $Script:TheSceneWindow.UpdateCurrentImage($Script:CurrentMap.GetTileAtPlayerCoordinates().BackgroundImage)
                    $Script:TheCommandWindow.UpdateCommandHistory($true)
                    $Script:CurrentMap.GetTileAtPlayerCoordinates().BattleStep()

                    Return
                }
            }
        } Else {
            $Script:TheCommandWindow.UpdateCommandHistory($true)
            $Script:TheMessageWindow.WriteYouShallNotPassMessage()

            Return
        }
    }

    [Boolean]ValidateSourceInFilter(
        [String]$SourceItemClass
    ) {
        Return ($SourceItemClass -IN $this.TargetOfFilter)
    }
}
