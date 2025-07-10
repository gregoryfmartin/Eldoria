using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEINFINITYCCTURTLEGAUNTLETS
#
###############################################################################

Class BEInfinityCCTurtleGauntlets : BEGauntlets {
    BEInfinityCCTurtleGauntlets() : base() {
        $this.Name = 'Infinity CC Turtle Gauntlets'
        $this.MapObjName = 'infinityccturtlegauntlets'
        $this.PurchasePrice = 230000
        $this.SellPrice = 0
        $this.TargetStats = @{
            [StatId]::Defense = 250
            [StatId]::MagicDefense = 250
            [StatId]::Accuracy = 250
        }
        $this.CanAddToInventory = $true
        $this.ExamineString = 'It sprays out lava.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
        $this.TargetGender = [Gender]::Unisex
    }
}
