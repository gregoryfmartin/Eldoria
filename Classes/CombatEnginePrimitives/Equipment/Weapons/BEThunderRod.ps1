using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE THUNDER ROD
#
###############################################################################

Class BEThunderRod : BEWeapon {
	BEThunderRod() : base() {
		$this.Name          = 'Thunder Rod'
		$this.MapObjName    = 'thunderrod'
		$this.PurchasePrice = 720
		$this.SellPrice     = 360
		$this.TargetStats   = @{
			[StatId]::Attack      = 8
			[StatId]::MagicAttack = 45
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A rod that can summon lightning bolts.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
