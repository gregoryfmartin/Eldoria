using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEASCENDANTSHALO
#
###############################################################################

Class BEAscendantsHalo : BEHelmet {
	BEAscendantsHalo() : base() {
		$this.Name               = 'Ascendant''s Halo'
		$this.MapObjName         = 'ascendantshalo'
		$this.PurchasePrice      = 2800
		$this.SellPrice          = 1400
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 28
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A halo that signifies ascension to a higher plane of existence.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
