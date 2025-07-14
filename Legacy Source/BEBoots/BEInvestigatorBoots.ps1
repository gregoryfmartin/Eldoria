using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEINVESTIGATORBOOTS
#
###############################################################################

Class BEInvestigatorBoots : BEBoots {
	BEInvestigatorBoots() : base() {
		$this.Name               = 'Investigator Boots'
		$this.MapObjName         = 'investigatorboots'
		$this.PurchasePrice      = 320
		$this.SellPrice          = 160
		$this.TargetStats        = @{
			[StatId]::Defense = 11
			[StatId]::MagicDefense = 11
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots for detectives.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
