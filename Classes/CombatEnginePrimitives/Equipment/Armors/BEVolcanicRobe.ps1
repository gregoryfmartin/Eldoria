using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEVOLCANICROBE
#
###############################################################################

Class BEVolcanicRobe : BEArmor {
	BEVolcanicRobe() : base() {
		$this.Name               = 'Volcanic Robe'
		$this.MapObjName         = 'volcanicrobe'
		$this.PurchasePrice      = 1700
		$this.SellPrice          = 850
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 36
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robe made from cooled lava, resisting extreme heat.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
