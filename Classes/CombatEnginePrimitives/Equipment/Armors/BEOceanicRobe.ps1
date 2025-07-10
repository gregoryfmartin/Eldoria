using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEOCEANICROBE
#
###############################################################################

Class BEOceanicRobe : BEArmor {
	BEOceanicRobe() : base() {
		$this.Name               = 'Oceanic Robe'
		$this.MapObjName         = 'oceanicrobe'
		$this.PurchasePrice      = 700
		$this.SellPrice          = 350
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 22
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robe woven from kelp and enchanted shells, good for water magic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
