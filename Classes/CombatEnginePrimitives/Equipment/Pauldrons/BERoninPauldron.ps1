using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BERONINPAULDRON
#
###############################################################################

Class BERoninPauldron : BEPauldron {
	BERoninPauldron() : base() {
		$this.Name               = 'Ronin Pauldron'
		$this.MapObjName         = 'roninpauldron'
		$this.PurchasePrice      = 9400
		$this.SellPrice          = 4700
		$this.TargetStats        = @{
			[StatId]::Defense = 188
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Worn by masterless warriors, showing signs of many battles.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}
