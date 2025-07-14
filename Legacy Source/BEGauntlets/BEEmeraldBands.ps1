using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEEMERALDBANDS
#
###############################################################################

Class BEEmeraldBands : BEGauntlets {
	BEEmeraldBands() : base() {
		$this.Name               = 'Emerald Bands'
		$this.MapObjName         = 'emeraldbands'
		$this.PurchasePrice      = 600
		$this.SellPrice          = 300
		$this.TargetStats        = @{
			[StatId]::Defense = 13
			[StatId]::MagicDefense = 21
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Bands gleaming with verdant energy, restoring vitality.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
