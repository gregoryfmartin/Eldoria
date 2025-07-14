using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BENEBULAHEART
#
###############################################################################

Class BENebulaHeart : BEJewelry {
	BENebulaHeart() : base() {
		$this.Name               = 'Nebula Heart'
		$this.MapObjName         = 'nebulaheart'
		$this.PurchasePrice      = 2100
		$this.SellPrice          = 1050
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 4
			[StatId]::MagicDefense = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A pulsating gem that resembles a distant nebula.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
