using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEELEMENTALMASTERSROBE
#
###############################################################################

Class BEElementalMastersRobe : BEArmor {
	BEElementalMastersRobe() : base() {
		$this.Name               = 'Elemental Master''s Robe'
		$this.MapObjName         = 'elementalmastersrobe'
		$this.PurchasePrice      = 2100
		$this.SellPrice          = 1050
		$this.TargetStats        = @{
			[StatId]::Defense = 5
			[StatId]::MagicDefense = 40
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robe imbued with the essence of all four elements, highly versatile.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
