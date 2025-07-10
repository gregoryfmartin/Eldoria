using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEWHISPERINGWILLOWAMULET
#
###############################################################################

Class BEWhisperingWillowAmulet : BEJewelry {
	BEWhisperingWillowAmulet() : base() {
		$this.Name               = 'Whispering Willow Amulet'
		$this.MapObjName         = 'whisperingwillowamulet'
		$this.PurchasePrice      = 680
		$this.SellPrice          = 340
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 1
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'An amulet carved from whispering willow wood.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
