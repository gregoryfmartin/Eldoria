using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEASHPAULDRON
#
###############################################################################

Class BEAshPauldron : BEPauldron {
	BEAshPauldron() : base() {
		$this.Name               = 'Ash Pauldron'
		$this.MapObjName         = 'ashpauldron'
		$this.PurchasePrice      = 3550
		$this.SellPrice          = 1775
		$this.TargetStats        = @{
			[StatId]::Defense = 71
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Coated in volcanic ash, offering protection from heat.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
