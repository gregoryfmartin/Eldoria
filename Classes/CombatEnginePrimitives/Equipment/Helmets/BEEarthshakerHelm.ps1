using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEEARTHSHAKERHELM
#
###############################################################################

Class BEEarthshakerHelm : BEHelmet {
	BEEarthshakerHelm() : base() {
		$this.Name               = 'Earthshaker Helm'
		$this.MapObjName         = 'earthshakerhelm'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{
			[StatId]::Defense = 15
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A heavy helm that resonates with the power of the earth, increasing physical might.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
