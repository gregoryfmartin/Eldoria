using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEMOONSTONEECLIPSEGAUNTLETS
#
###############################################################################

Class BEMoonstoneEclipseGauntlets : BEGauntlets {
	BEMoonstoneEclipseGauntlets() : base() {
		$this.Name               = 'Moonstone Eclipse Gauntlets'
		$this.MapObjName         = 'moonstoneeclipsegauntlets'
		$this.PurchasePrice      = 1050
		$this.SellPrice          = 525
		$this.TargetStats        = @{
			[StatId]::Defense = 22
			[StatId]::MagicDefense = 40
			[StatId]::Accuracy = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Bracers that absorb moonlight, enhancing night vision and stealth.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Female
	}
}
