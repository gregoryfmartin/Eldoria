using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE ENCHANTERS HOOD
#
###############################################################################

Class BEEnchantersHood : BEHelmet {
	BEEnchantersHood() : base() {
		$this.Name               = 'Enchanter''s Hood'
		$this.MapObjName         = 'enchantershood'
		$this.PurchasePrice      = 130
		$this.SellPrice          = 65
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 6
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A mystical hood that aids in the art of enchantment.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
