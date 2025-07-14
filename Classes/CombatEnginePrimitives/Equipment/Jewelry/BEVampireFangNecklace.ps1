using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEVAMPIREFANGNECKLACE
#
###############################################################################

Class BEVampireFangNecklace : BEJewelry {
	BEVampireFangNecklace() : base() {
		$this.Name               = 'Vampire Fang Necklace'
		$this.MapObjName         = 'vampirefangnecklace'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{
			[StatId]::Attack = 1
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A dark necklace adorned with a vampire fang, siphoning life.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
