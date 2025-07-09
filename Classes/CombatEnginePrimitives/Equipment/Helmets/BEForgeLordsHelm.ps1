using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE FORGE LORD'S HELM
#
###############################################################################

Class BEForgeLordsHelm : BEHelmet {
	BEForgeLordsHelm() : base() {
		$this.Name               = 'Forge Lord''s Helm'
		$this.MapObjName         = 'forgelordshelm'
		$this.PurchasePrice      = 1800
		$this.SellPrice          = 900
		$this.TargetStats        = @{
			[StatId]::Defense = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A heavy helm worn by master blacksmiths, radiating immense heat.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}
