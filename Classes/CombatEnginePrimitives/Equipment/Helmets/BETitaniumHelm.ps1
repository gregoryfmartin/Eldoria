using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE TITANIUM HELM
#
###############################################################################

Class BETitaniumHelm : BEHelmet {
	BETitaniumHelm() : base() {
		$this.Name               = 'Titanium Helm'
		$this.MapObjName         = 'titaniumhelm'
		$this.PurchasePrice      = 1500
		$this.SellPrice          = 750
		$this.TargetStats        = @{
			[StatId]::Defense = 15
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A lightweight yet incredibly strong helm made from titanium.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
