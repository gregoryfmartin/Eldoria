using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECHAMPIONSPAULDRON
#
###############################################################################

Class BEChampionsPauldron : BEPauldron {
	BEChampionsPauldron() : base() {
		$this.Name               = 'Champion''s Pauldron'
		$this.MapObjName         = 'championspauldron'
		$this.PurchasePrice      = 850
		$this.SellPrice          = 425
		$this.TargetStats        = @{
			[StatId]::Defense = 17
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Worn by the undefeated champions of the arena.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}
