using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESUNKENTREASUREROBE
#
###############################################################################

Class BESunkenTreasureRobe : BEArmor {
	BESunkenTreasureRobe() : base() {
		$this.Name               = 'Sunken Treasure Robe'
		$this.MapObjName         = 'sunkentreasurerobe'
		$this.PurchasePrice      = 1400
		$this.SellPrice          = 700
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 33
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robe encrusted with pearls and gems from sunken ships, carries a sea enchantment.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
