using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEVALKYRIEPAULDRON
#
###############################################################################

Class BEValkyriePauldron : BEPauldron {
	BEValkyriePauldron() : base() {
		$this.Name               = 'Valkyrie Pauldron'
		$this.MapObjName         = 'valkyriepauldron'
		$this.PurchasePrice      = 800
		$this.SellPrice          = 400
		$this.TargetStats        = @{
			[StatId]::Defense = 16
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Shines with divine light, granting protection to its wearer.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Female
	}
}
