using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDIAMONDCROWN
#
###############################################################################

Class BEDiamondCrown : BEHelmet {
	BEDiamondCrown() : base() {
		$this.Name               = 'Diamond Crown'
		$this.MapObjName         = 'diamondcrown'
		$this.PurchasePrice      = 3800
		$this.SellPrice          = 1900
		$this.TargetStats        = @{
			[StatId]::Defense = 10
			[StatId]::MagicDefense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A crown encrusted with diamonds, offering unparalleled defense and prestige.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
