using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE ROYAL GUARD HELM
#
###############################################################################

Class BERoyalGuardHelm : BEHelmet {
	BERoyalGuardHelm() : base() {
		$this.Name               = 'Royal Guard Helm'
		$this.MapObjName         = 'royalguardhelm'
		$this.PurchasePrice      = 1500
		$this.SellPrice          = 750
		$this.TargetStats        = @{
			[StatId]::Defense = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A highly ornate helm worn by royal guards, signifying their loyalty.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
