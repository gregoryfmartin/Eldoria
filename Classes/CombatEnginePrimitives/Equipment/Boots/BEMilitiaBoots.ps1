using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEMILITIABOOTS
#
###############################################################################

Class BEMilitiaBoots : BEBoots {
	BEMilitiaBoots() : base() {
		$this.Name               = 'Militia Boots'
		$this.MapObjName         = 'militiaboots'
		$this.PurchasePrice      = 130
		$this.SellPrice          = 65
		$this.TargetStats        = @{
			[StatId]::Defense = 5
			[StatId]::MagicDefense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots for civilian defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
