using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BENECROMANCERSTOTEM
#
###############################################################################

Class BENecromancersTotem : BEJewelry {
	BENecromancersTotem() : base() {
		$this.Name               = 'Necromancer''s Totem'
		$this.MapObjName         = 'necromancerstotem'
		$this.PurchasePrice      = 1500
		$this.SellPrice          = 750
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A dark totem crafted from bone and shadows.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Male
	}
}
