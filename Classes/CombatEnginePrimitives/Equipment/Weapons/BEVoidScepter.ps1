using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEVOIDSCEPTER
#
###############################################################################

Class BEVoidScepter : BEWeapon {
	BEVoidScepter() : base() {
		$this.Name          = 'Void Scepter'
		$this.MapObjName    = 'voidscepter'
		$this.PurchasePrice = 1000
		$this.SellPrice     = 500
		$this.TargetStats   = @{
			[StatId]::Attack      = 15
			[StatId]::MagicAttack = 60
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A scepter that can manipulate spatial anomalies.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
