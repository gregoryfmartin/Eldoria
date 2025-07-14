using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDRAGONSBREATHGAUNTLETS
#
###############################################################################

Class BEDragonsBreathGauntlets : BEGauntlets {
	BEDragonsBreathGauntlets() : base() {
		$this.Name               = 'Dragon''s Breath Gauntlets'
		$this.MapObjName         = 'dragonsbreathgauntlets'
		$this.PurchasePrice      = 2300
		$this.SellPrice          = 1150
		$this.TargetStats        = @{
			[StatId]::Defense = 110
			[StatId]::MagicDefense = 40
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets imbued with a dragon''s fiery breath.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
