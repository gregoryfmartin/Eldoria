using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEPLAGUEDBOOTS
#
###############################################################################

Class BEPlaguedBoots : BEBoots {
	BEPlaguedBoots() : base() {
		$this.Name               = 'Plagued Boots'
		$this.MapObjName         = 'plaguedboots'
		$this.PurchasePrice      = 800
		$this.SellPrice          = 400
		$this.TargetStats        = @{
			[StatId]::Defense = 29
			[StatId]::MagicDefense = 14
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots spreading disease and decay.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
