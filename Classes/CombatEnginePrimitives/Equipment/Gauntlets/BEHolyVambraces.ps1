using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEHOLYVAMBRACES
#
###############################################################################

Class BEHolyVambraces : BEGauntlets {
	BEHolyVambraces() : base() {
		$this.Name               = 'Holy Vambraces'
		$this.MapObjName         = 'holyvambraces'
		$this.PurchasePrice      = 1350
		$this.SellPrice          = 675
		$this.TargetStats        = @{
			[StatId]::Defense = 62
			[StatId]::MagicDefense = 25
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Vambraces blessed by sacred rites, warding off evil.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
