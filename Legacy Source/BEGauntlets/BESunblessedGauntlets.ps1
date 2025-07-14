using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESUNBLESSEDGAUNTLETS
#
###############################################################################

Class BESunblessedGauntlets : BEGauntlets {
	BESunblessedGauntlets() : base() {
		$this.Name               = 'Sunblessed Gauntlets'
		$this.MapObjName         = 'sunblessedgauntlets'
		$this.PurchasePrice      = 1050
		$this.SellPrice          = 525
		$this.TargetStats        = @{
			[StatId]::Defense = 33
			[StatId]::MagicDefense = 35
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets infused with the sun''s warmth, healing allies.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
