using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEINVESTIGATORGREAVES
#
###############################################################################

Class BEInvestigatorGreaves : BEGreaves {
	BEInvestigatorGreaves() : base() {
		$this.Name               = 'Investigator Greaves'
		$this.MapObjName         = 'investigatorgreaves'
		$this.PurchasePrice      = 350
		$this.SellPrice          = 175
		$this.TargetStats        = @{
			[StatId]::Defense = 12
			[StatId]::MagicDefense = 12
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves for detectives.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
