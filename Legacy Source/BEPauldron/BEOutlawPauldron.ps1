using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEOUTLAWPAULDRON
#
###############################################################################

Class BEOutlawPauldron : BEPauldron {
	BEOutlawPauldron() : base() {
		$this.Name               = 'Outlaw Pauldron'
		$this.MapObjName         = 'outlawpauldron'
		$this.PurchasePrice      = 2000
		$this.SellPrice          = 1000
		$this.TargetStats        = @{
			[StatId]::Defense = 40
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Favored by those who operate outside the law.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}
