using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGLACIALBREASTPLATE
#
###############################################################################

Class BEGlacialBreastplate : BEArmor {
	BEGlacialBreastplate() : base() {
		$this.Name               = 'Glacial Breastplate'
		$this.MapObjName         = 'glacialbreastplate'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{
			[StatId]::Defense = 22
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A breastplate emanating a freezing aura, good against fire.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
