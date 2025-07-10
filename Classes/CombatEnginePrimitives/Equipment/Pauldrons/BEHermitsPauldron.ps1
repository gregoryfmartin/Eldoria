using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEHERMITSPAULDRON
#
###############################################################################

Class BEHermitsPauldron : BEPauldron {
	BEHermitsPauldron() : base() {
		$this.Name               = 'Hermit''s Pauldron'
		$this.MapObjName         = 'hermitspauldron'
		$this.PurchasePrice      = 9100
		$this.SellPrice          = 4550
		$this.TargetStats        = @{
			[StatId]::Defense = 182
			[StatId]::MagicDefense = 81
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Worn by reclusive sages, offering subtle, ancient protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
