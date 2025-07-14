using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEZENMASTERPAULDRON
#
###############################################################################

Class BEZenMasterPauldron : BEPauldron {
	BEZenMasterPauldron() : base() {
		$this.Name               = 'Zen Master Pauldron'
		$this.MapObjName         = 'zenmasterpauldron'
		$this.PurchasePrice      = 9200
		$this.SellPrice          = 4600
		$this.TargetStats        = @{
			[StatId]::Defense = 184
			[StatId]::MagicDefense = 83
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Channels inner peace into powerful, disciplined defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
