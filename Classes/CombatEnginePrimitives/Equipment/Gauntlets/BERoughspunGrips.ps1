using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEROUGHSPUNGRIPS
#
###############################################################################

Class BERoughspunGrips : BEGauntlets {
	BERoughspunGrips() : base() {
		$this.Name               = 'Roughspun Grips'
		$this.MapObjName         = 'roughspungrips'
		$this.PurchasePrice      = 60
		$this.SellPrice          = 30
		$this.TargetStats        = @{
			[StatId]::Defense = 2
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Crude, but surprisingly durable gloves.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
