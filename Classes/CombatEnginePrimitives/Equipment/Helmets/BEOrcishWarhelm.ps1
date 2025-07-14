using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEORCISHWARHELM
#
###############################################################################

Class BEOrcishWarhelm : BEHelmet {
	BEOrcishWarhelm() : base() {
		$this.Name               = 'Orcish Warhelm'
		$this.MapObjName         = 'orcishwarhelm'
		$this.PurchasePrice      = 250
		$this.SellPrice          = 125
		$this.TargetStats        = @{
			[StatId]::Defense = 9
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A crude but brutal warhelm, favored by orcish warriors.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
