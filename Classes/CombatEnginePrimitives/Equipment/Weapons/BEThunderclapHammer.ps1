using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BETHUNDERCLAPHAMMER
#
###############################################################################

Class BEThunderclapHammer : BEWeapon {
	BEThunderclapHammer() : base() {
		$this.Name          = 'Thunderclap Hammer'
		$this.MapObjName    = 'thunderclaphammer'
		$this.PurchasePrice = 4900
		$this.SellPrice     = 2450
		$this.TargetStats   = @{
			[StatId]::Attack      = 128
			[StatId]::MagicAttack = 15
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A hammer that emits a concussive shockwave upon impact.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
