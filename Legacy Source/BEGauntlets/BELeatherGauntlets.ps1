using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BELEATHERGAUNTLETS
#
###############################################################################

Class BELeatherGauntlets : BEGauntlets {
	BELeatherGauntlets() : base() {
		$this.Name               = 'Leather Gauntlets'
		$this.MapObjName         = 'leathergauntlets'
		$this.PurchasePrice      = 80
		$this.SellPrice          = 40
		$this.TargetStats        = @{
			[StatId]::Defense = 3
			[StatId]::MagicDefense = 4
			[StatId]::Accuracy = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Lightweight leather gloves, offering dexterity with minimal defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Unisex
	}
}
