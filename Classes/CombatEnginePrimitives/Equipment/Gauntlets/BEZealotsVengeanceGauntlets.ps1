using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEZEALOTSVENGEANCEGAUNTLETS
#
###############################################################################

Class BEZealotsVengeanceGauntlets : BEGauntlets {
	BEZealotsVengeanceGauntlets() : base() {
		$this.Name               = 'Zealot''s Vengeance Gauntlets'
		$this.MapObjName         = 'zealotsvengeancegauntlets'
		$this.PurchasePrice      = 600
		$this.SellPrice          = 300
		$this.TargetStats        = @{
			[StatId]::Defense = 30
			[StatId]::MagicDefense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets of a vengeful zealot, empowering their strikes.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
