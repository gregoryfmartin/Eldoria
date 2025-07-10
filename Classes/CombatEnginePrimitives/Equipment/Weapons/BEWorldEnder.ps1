using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEWORLDENDER
#
###############################################################################

Class BEWorldEnder : BEWeapon {
	BEWorldEnder() : base() {
		$this.Name          = 'World Ender'
		$this.MapObjName    = 'worldender'
		$this.PurchasePrice = 7000
		$this.SellPrice     = 3500
		$this.TargetStats   = @{
			[StatId]::Attack      = 200
			[StatId]::MagicAttack = 100
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A legendary weapon capable of cataclysmic destruction, forbidden to wield.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
