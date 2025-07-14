using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESORCERERCAPE
#
###############################################################################

Class BESorcererCape : BECape {
	BESorcererCape() : base() {
		$this.Name               = 'Sorcerer Cape'
		$this.MapObjName         = 'sorcerercape'
		$this.PurchasePrice      = 350
		$this.SellPrice          = 175
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A flowing cape, subtly enhancing magical flow.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Male
	}
}
