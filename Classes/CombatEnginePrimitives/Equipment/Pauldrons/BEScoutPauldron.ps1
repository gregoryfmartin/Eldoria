using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESCOUTPAULDRON
#
###############################################################################

Class BEScoutPauldron : BEPauldron {
	BEScoutPauldron() : base() {
		$this.Name               = 'Scout Pauldron'
		$this.MapObjName         = 'scoutpauldron'
		$this.PurchasePrice      = 1850
		$this.SellPrice          = 925
		$this.TargetStats        = @{
			[StatId]::Defense = 37
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Lightweight and practical for long journeys and reconnaissance.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}
