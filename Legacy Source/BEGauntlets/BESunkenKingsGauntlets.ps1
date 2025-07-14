using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESUNKENKINGSGAUNTLETS
#
###############################################################################

Class BESunkenKingsGauntlets : BEGauntlets {
	BESunkenKingsGauntlets() : base() {
		$this.Name               = 'Sunken King''s Gauntlets'
		$this.MapObjName         = 'sunkenkingsgauntlets'
		$this.PurchasePrice      = 1500
		$this.SellPrice          = 750
		$this.TargetStats        = @{
			[StatId]::Defense = 70
			[StatId]::MagicDefense = 30
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets of a forgotten underwater king, granting aquatic power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
