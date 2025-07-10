using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEEXCAVATORGREAVES
#
###############################################################################

Class BEExcavatorGreaves : BEGreaves {
	BEExcavatorGreaves() : base() {
		$this.Name               = 'Excavator Greaves'
		$this.MapObjName         = 'excavatorgreaves'
		$this.PurchasePrice      = 350
		$this.SellPrice          = 175
		$this.TargetStats        = @{
			[StatId]::Defense = 12
			[StatId]::MagicDefense = 7
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves for deep digging.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
