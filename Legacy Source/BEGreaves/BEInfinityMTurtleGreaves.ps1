using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEINFINITYMTURTLEGREAVES
#
###############################################################################

Class BEInfinityMTurtleGreaves : BEGreaves {
    BEInfinityMTurtleGreaves() : base() {
		$this.Name               = 'Infinity M Turtle Greaves'
		$this.MapObjName         = 'infinitymturtlegreaves'
		$this.PurchasePrice      = 750000
		$this.SellPrice          = 0
		$this.TargetStats        = @{
			[StatId]::Defense = 255
			[StatId]::MagicDefense = 255
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'They shoot out Minecraft Creepers.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
    }
}
