using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEMARAUDERSPAULDRON
#
###############################################################################

Class BEMaraudersPauldron : BEPauldron {
	BEMaraudersPauldron() : base() {
		$this.Name               = 'Marauder''s Pauldron'
		$this.MapObjName         = 'marauderspauldron'
		$this.PurchasePrice      = 2050
		$this.SellPrice          = 1025
		$this.TargetStats        = @{
			[StatId]::Defense = 41
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Aggressive and functional, for those who take what they want.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}
