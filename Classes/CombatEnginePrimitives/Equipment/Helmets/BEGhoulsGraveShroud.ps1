using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE GHOUL'S GRAVE SHROUD
#
###############################################################################

Class BEGhoulsGraveShroud : BEHelmet {
	BEGhoulsGraveShroud() : base() {
		$this.Name               = 'Ghoul''s Grave Shroud'
		$this.MapObjName         = 'ghoulsgraveshroud'
		$this.PurchasePrice      = 1400
		$this.SellPrice          = 700
		$this.TargetStats        = @{
			[StatId]::Defense = 6
			[StatId]::MagicDefense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A tattered shroud that grants the wearer partial invisibility in darkness.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
