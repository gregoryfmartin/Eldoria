using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGUARDIANSPAULDRON
#
###############################################################################

Class BEGuardiansPauldron : BEPauldron {
	BEGuardiansPauldron() : base() {
		$this.Name               = 'Guardian''s Pauldron'
		$this.MapObjName         = 'guardianspauldron'
		$this.PurchasePrice      = 1250
		$this.SellPrice          = 625
		$this.TargetStats        = @{
			[StatId]::Defense = 25
			[StatId]::MagicDefense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Imbued with protective magic, shielding its wearer from harm.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
