using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECORRUPTEDBOOTS
#
###############################################################################

Class BECorruptedBoots : BEBoots {
	BECorruptedBoots() : base() {
		$this.Name               = 'Corrupted Boots'
		$this.MapObjName         = 'corruptedboots'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{
			[StatId]::Defense = 40
			[StatId]::MagicDefense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots twisted by dark forces.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
