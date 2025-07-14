using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESTEELBOOTS
#
###############################################################################

Class BESteelBoots : BEBoots {
	BESteelBoots() : base() {
		$this.Name               = 'Steel Boots'
		$this.MapObjName         = 'steelboots'
		$this.PurchasePrice      = 320
		$this.SellPrice          = 160
		$this.TargetStats        = @{
			[StatId]::Defense = 15
			[StatId]::MagicDefense = 6
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Heavy steel boots, offering solid defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
