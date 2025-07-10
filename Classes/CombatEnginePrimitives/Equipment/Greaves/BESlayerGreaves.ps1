using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESLAYERGREAVES
#
###############################################################################

Class BESlayerGreaves : BEGreaves {
	BESlayerGreaves() : base() {
		$this.Name               = 'Slayer Greaves'
		$this.MapObjName         = 'slayergreaves'
		$this.PurchasePrice      = 900
		$this.SellPrice          = 450
		$this.TargetStats        = @{
			[StatId]::Defense = 38
			[StatId]::MagicDefense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves of a monster hunter.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
