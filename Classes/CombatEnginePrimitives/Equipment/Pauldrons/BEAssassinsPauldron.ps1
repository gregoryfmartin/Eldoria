using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEASSASSINSPAULDRON
#
###############################################################################

Class BEAssassinsPauldron : BEPauldron {
	BEAssassinsPauldron() : base() {
		$this.Name               = 'Assassin''s Pauldron'
		$this.MapObjName         = 'assassinspauldron'
		$this.PurchasePrice      = 1700
		$this.SellPrice          = 850
		$this.TargetStats        = @{
			[StatId]::Defense = 34
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Light and agile, perfect for striking from the shadows.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}
