using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEPHOENIXBOW
#
###############################################################################

Class BEPhoenixBow : BEWeapon {
	BEPhoenixBow() : base() {
		$this.Name          = 'Phoenix Bow'
		$this.MapObjName    = 'phoenixbow'
		$this.PurchasePrice = 1250
		$this.SellPrice     = 625
		$this.TargetStats   = @{
			[StatId]::Attack      = 63
			[StatId]::MagicAttack = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A bow adorned with phoenix feathers, allowing arrows to ignite upon impact.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
