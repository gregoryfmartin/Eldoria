using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEOGREPAULDRON
#
###############################################################################

Class BEOgrePauldron : BEPauldron {
	BEOgrePauldron() : base() {
		$this.Name               = 'Ogre Pauldron'
		$this.MapObjName         = 'ogrepauldron'
		$this.PurchasePrice      = 3350
		$this.SellPrice          = 1675
		$this.TargetStats        = @{
			[StatId]::Defense = 67
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Crude but effective, worn by large, brutish fighters.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}
