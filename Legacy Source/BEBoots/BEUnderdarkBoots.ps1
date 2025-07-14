using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEUNDERDARKBOOTS
#
###############################################################################

Class BEUnderdarkBoots : BEBoots {
	BEUnderdarkBoots() : base() {
		$this.Name               = 'Underdark Boots'
		$this.MapObjName         = 'underdarkboots'
		$this.PurchasePrice      = 950
		$this.SellPrice          = 475
		$this.TargetStats        = @{
			[StatId]::Defense = 37
			[StatId]::MagicDefense = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots for the deep and dangerous underground.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
