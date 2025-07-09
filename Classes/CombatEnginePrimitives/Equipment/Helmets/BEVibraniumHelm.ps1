using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE VIBRAINUM HELM
#
###############################################################################

Class BEVibraniumHelm : BEHelmet {
	BEVibraniumHelm() : base() {
		$this.Name               = 'Vibranium Helm'
		$this.MapObjName         = 'vibraniumhelm'
		$this.PurchasePrice      = 5000
		$this.SellPrice          = 2500
		$this.TargetStats        = @{
			[StatId]::Defense = 35
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm made from vibranium, absorbing kinetic energy and returning it as force.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
