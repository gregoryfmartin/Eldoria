using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEAPPRENTICESMITTS
#
###############################################################################

Class BEApprenticesMitts : BEGauntlets {
	BEApprenticesMitts() : base() {
		$this.Name               = 'Apprentice''s Mitts'
		$this.MapObjName         = 'apprenticesmitts'
		$this.PurchasePrice      = 90
		$this.SellPrice          = 45
		$this.TargetStats        = @{
			[StatId]::Defense = 3
			[StatId]::MagicDefense = 6
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Basic gloves for a budding spellcaster.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
