using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDREADNOUGHTHELM
#
###############################################################################

Class BEDreadnoughtHelm : BEHelmet {
	BEDreadnoughtHelm() : base() {
		$this.Name               = 'Dreadnought Helm'
		$this.MapObjName         = 'dreadnoughthelm'
		$this.PurchasePrice      = 2500
		$this.SellPrice          = 1250
		$this.TargetStats        = @{
			[StatId]::Defense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A massive, heavily armored helm designed for ultimate defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
