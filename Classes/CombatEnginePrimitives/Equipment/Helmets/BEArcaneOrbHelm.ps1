using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE ARCANE ORB HELM
#
###############################################################################

Class BEArcaneOrbHelm : BEHelmet {
	BEArcaneOrbHelm() : base() {
		$this.Name               = 'Arcane Orb Helm'
		$this.MapObjName         = 'arcaneorbhelm'
		$this.PurchasePrice      = 2800
		$this.SellPrice          = 1400
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 25
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm with a floating arcane orb, significantly boosting magical power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
