using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BETATTEREDCAPE
#
###############################################################################

Class BETatteredCape : BECape {
	BETatteredCape() : base() {
		$this.Name               = 'Tattered Cape'
		$this.MapObjName         = 'tatteredcape'
		$this.PurchasePrice      = 50
		$this.SellPrice          = 25
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A worn and torn cape, offering minimal protection.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Unisex
	}
}
