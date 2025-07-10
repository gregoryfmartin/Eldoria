using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEWOVENVINEGLOVES
#
###############################################################################

Class BEWovenVineGloves : BEGauntlets {
	BEWovenVineGloves() : base() {
		$this.Name               = 'Woven Vine Gloves'
		$this.MapObjName         = 'wovenvinegloves'
		$this.PurchasePrice      = 120
		$this.SellPrice          = 60
		$this.TargetStats        = @{
			[StatId]::Defense = 4
			[StatId]::MagicDefense = 6
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gloves crafted from strong, flexible vines.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
