using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BODYGUARD'S HELM
#
###############################################################################

Class BEBodyguardsHelm : BEHelmet {
	BEBodyguardsHelm() : base() {
		$this.Name               = 'Bodyguard''s Helm'
		$this.MapObjName         = 'bodyguardshelm'
		$this.PurchasePrice      = 250
		$this.SellPrice          = 125
		$this.TargetStats        = @{
			[StatId]::Defense = 8
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A heavy helm for bodyguards, ensuring the protection of their charge.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}
