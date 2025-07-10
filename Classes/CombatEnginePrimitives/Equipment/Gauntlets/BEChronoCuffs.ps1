using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECHRONOCUFFS
#
###############################################################################

Class BEChronoCuffs : BEGauntlets {
	BEChronoCuffs() : base() {
		$this.Name               = 'Chrono Cuffs'
		$this.MapObjName         = 'chronocuffs'
		$this.PurchasePrice      = 900
		$this.SellPrice          = 450
		$this.TargetStats        = @{
			[StatId]::Defense = 15
			[StatId]::MagicDefense = 25
			[StatId]::Accuracy = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Cuffs that subtly manipulate time, improving reaction speed.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Unisex
	}
}
