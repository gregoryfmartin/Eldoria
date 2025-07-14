using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESKYFARERPAULDRON
#
###############################################################################

Class BESkyfarerPauldron : BEPauldron {
	BESkyfarerPauldron() : base() {
		$this.Name               = 'Skyfarer Pauldron'
		$this.MapObjName         = 'skyfarerpauldron'
		$this.PurchasePrice      = 2800
		$this.SellPrice          = 1400
		$this.TargetStats        = @{
			[StatId]::Defense = 56
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Lightweight and aerodynamic, for those who travel the skies.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}
