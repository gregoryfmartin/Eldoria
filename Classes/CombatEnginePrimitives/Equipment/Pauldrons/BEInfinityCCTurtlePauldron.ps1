using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEINFINITYCCTURTLEPAULDRON
#
###############################################################################

Class BEInfinityCCTurtlePauldron : BEPauldron {
    BEInfinityCCTurtlePauldron() : base() {
        $this.Name               = 'Infinity CC Turtle Pauldron'
        $this.MapObjName         = 'infinityccturtlepauldron'
        $this.PurchasePrice      = 250000
        $this.SellPrice          = 0
        $this.TargetStats        = @{
            [StatId]::Defense      = 250
            [StatId]::MagicDefense = 250
        }
        $this.CanAddToInventory  = $true
        $this.ExamineString      = 'It spawns 1M trees falling down on their head.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
        $this.TargetGender       = [Gender]::Unisex
    }
}
