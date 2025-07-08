using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE WARRIORS GREATHELM
#
###############################################################################

Class BEWarriorsGreathelm : BEHelmet {
	BEWarriorsGreathelm() : base() {
		$this.Name               = 'Warrior''s Greathelm'
		$this.MapObjName         = 'warriorsgreathelm'
		$this.PurchasePrice      = 350
		$this.SellPrice          = 175
		$this.TargetStats        = @{
			[StatId]::Defense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A heavy greathelm designed for powerful warriors, offering maximum frontal defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}
