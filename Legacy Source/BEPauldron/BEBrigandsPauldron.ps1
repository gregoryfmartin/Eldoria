using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEBRIGANDSPAULDRON
#
###############################################################################

Class BEBrigandsPauldron : BEPauldron {
	BEBrigandsPauldron() : base() {
		$this.Name               = 'Brigand''s Pauldron'
		$this.MapObjName         = 'brigandspauldron'
		$this.PurchasePrice      = 1950
		$this.SellPrice          = 975
		$this.TargetStats        = @{
			[StatId]::Defense = 39
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Roughly made but effective for those who live by their wits.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}
