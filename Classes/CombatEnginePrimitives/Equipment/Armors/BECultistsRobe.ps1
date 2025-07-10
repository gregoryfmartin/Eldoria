using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECULTISTSROBE
#
###############################################################################

Class BECultistsRobe : BEArmor {
	BECultistsRobe() : base() {
		$this.Name               = 'Cultist''s Robe'
		$this.MapObjName         = 'cultistsrobe'
		$this.PurchasePrice      = 300
		$this.SellPrice          = 150
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 15
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A dark and ominous robe, often worn by followers of dark deities.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
