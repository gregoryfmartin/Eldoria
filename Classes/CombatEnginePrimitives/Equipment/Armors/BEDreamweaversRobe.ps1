using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDREAMWEAVERSROBE
#
###############################################################################

Class BEDreamweaversRobe : BEArmor {
	BEDreamweaversRobe() : base() {
		$this.Name               = 'Dreamweaver''s Robe'
		$this.MapObjName         = 'dreamweaversrobe'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 28
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robe that helps its wearer control dreams, useful for illusions.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
