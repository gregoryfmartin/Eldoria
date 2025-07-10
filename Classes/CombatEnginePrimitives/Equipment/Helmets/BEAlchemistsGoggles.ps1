using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEALCHEMISTSGOGGLES
#
###############################################################################

Class BEAlchemistsGoggles : BEHelmet {
	BEAlchemistsGoggles() : base() {
		$this.Name               = 'Alchemist''s Goggles'
		$this.MapObjName         = 'alchemistsgoggles'
		$this.PurchasePrice      = 50
		$this.SellPrice          = 25
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Goggles designed to protect the eyes of alchemists during experiments.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
