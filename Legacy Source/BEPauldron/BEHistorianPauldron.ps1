using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEHISTORIANPAULDRON
#
###############################################################################

Class BEHistorianPauldron : BEPauldron {
	BEHistorianPauldron() : base() {
		$this.Name               = 'Historian Pauldron'
		$this.MapObjName         = 'historianpauldron'
		$this.PurchasePrice      = 9800
		$this.SellPrice          = 4900
		$this.TargetStats        = @{
			[StatId]::Defense = 196
			[StatId]::MagicDefense = 88
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Grants insight into the past, revealing hidden truths.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
