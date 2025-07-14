using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEPALADINSOATHSCROLL
#
###############################################################################

Class BEPaladinsOathScroll : BEJewelry {
	BEPaladinsOathScroll() : base() {
		$this.Name               = 'Paladin''s Oath Scroll'
		$this.MapObjName         = 'paladinsoathscroll'
		$this.PurchasePrice      = 1500
		$this.SellPrice          = 750
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A miniature scroll inscribed with a holy oath.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
