using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE WORLD TREE BOW
#
###############################################################################

Class BEWorldTreeBow : BEWeapon {
	BEWorldTreeBow() : base() {
		$this.Name          = 'World Tree Bow'
		$this.MapObjName    = 'worldtreebow'
		$this.PurchasePrice = 6000
		$this.SellPrice     = 3000
		$this.TargetStats   = @{
			[StatId]::Attack      = 130
			[StatId]::MagicAttack = 40
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A bow carved from a branch of the World Tree, its arrows carry life energy.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
