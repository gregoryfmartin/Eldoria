using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEFENCERPAULDRON
#
###############################################################################

Class BEFencerPauldron : BEPauldron {
	BEFencerPauldron() : base() {
		$this.Name               = 'Fencer Pauldron'
		$this.MapObjName         = 'fencerpauldron'
		$this.PurchasePrice      = 8150
		$this.SellPrice          = 4075
		$this.TargetStats        = @{
			[StatId]::Defense = 163
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Light and unrestrictive, for rapid thrusts and parries.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}
