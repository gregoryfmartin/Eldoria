using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# ENEMY BATTLE ENTITY
#
# AN ENTITY THAT IS NOT THE PLAYER THAT CAN BE ENCOUNTERED IN A BATTLE 
# SCENARIO.
#
###############################################################################

Class EnemyBattleEntity : BattleEntity {
    [EnemyEntityImage]$Image
    [Int]$SpoilsGold
    [MapTileObject[]]$SpoilsItems

    EnemyBattleEntity() {
        $this.Image = $null
        $this.SpoilsGold = 0
        $this.SpoilsItems = @()
        $this.SpoilsEffect = {
            Param(
                [Player]$Player,
                [EnemyBattleEntity]$Opponent
            )

            $Script:TheBattleStatusMessageWindow.WriteSpoilsMessage($Opponent)
            $Script:TheBattleStatusMessageWindow.Draw()
            $Player.CurrentGold += $Opponent.SpoilsGold
            If($Opponent.SpoilsItems.Length -GT 0) {
                [String]$ItemNames = ($Opponent.SpoilsItems | Select-Object -ExpandProperty 'Name') -JOIN ', '
                
                $Script:TheBattleStatusMessageWindow.WriteItemsFoundMessage($ItemNames)
                $Script:TheBattleStatusMessageWindow.Draw()
                Foreach($a in $Opponent.SpoilsItems) {
                    $Player.Inventory.Add($a) | Out-Null
                }
            }
        }
    }
}
