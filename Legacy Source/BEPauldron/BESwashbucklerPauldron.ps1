using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESWASHBUCKLERPAULDRON
#
###############################################################################

Class BESwashbucklerPauldron : BEPauldron {
	BESwashbucklerPauldron() : base() {
		$this.Name               = 'Swashbuckler Pauldron'
		$this.MapObjName         = 'swashbucklerpauldron'
		$this.PurchasePrice      = 8200
		$this.SellPrice          = 4100
		$this.TargetStats        = @{
			[StatId]::Defense = 164
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Stylish yet practical, for those who fight with flair.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}
