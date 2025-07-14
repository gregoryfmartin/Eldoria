using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEWARLORDSGREATHELM
#
###############################################################################

Class BEWarlordsGreathelm : BEHelmet {
	BEWarlordsGreathelm() : base() {
		$this.Name               = 'Warlord''s Greathelm'
		$this.MapObjName         = 'warlordsgreathelm'
		$this.PurchasePrice      = 2500
		$this.SellPrice          = 1250
		$this.TargetStats        = @{
			[StatId]::Defense = 25
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A massive greathelm worn by powerful warlords, dominating the battlefield.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}
