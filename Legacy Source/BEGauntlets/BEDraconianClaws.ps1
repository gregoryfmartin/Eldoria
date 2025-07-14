using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDRACONIANCLAWS
#
###############################################################################

Class BEDraconianClaws : BEGauntlets {
	BEDraconianClaws() : base() {
		$this.Name               = 'Draconian Claws'
		$this.MapObjName         = 'draconianclaws'
		$this.PurchasePrice      = 600
		$this.SellPrice          = 300
		$this.TargetStats        = @{
			[StatId]::Defense = 28
			[StatId]::MagicDefense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets crafted from dragon scales, exceptionally strong.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
