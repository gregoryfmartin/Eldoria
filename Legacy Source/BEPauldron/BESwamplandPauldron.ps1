using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESWAMPLANDPAULDRON
#
###############################################################################

Class BESwamplandPauldron : BEPauldron {
	BESwamplandPauldron() : base() {
		$this.Name               = 'Swampland Pauldron'
		$this.MapObjName         = 'swamplandpauldron'
		$this.PurchasePrice      = 2700
		$this.SellPrice          = 1350
		$this.TargetStats        = @{
			[StatId]::Defense = 54
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Resistant to moisture and disease, for traversing murky waters.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}
