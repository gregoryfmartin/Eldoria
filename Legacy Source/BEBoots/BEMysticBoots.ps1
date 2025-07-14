using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEMYSTICBOOTS
#
###############################################################################

Class BEMysticBoots : BEBoots {
	BEMysticBoots() : base() {
		$this.Name               = 'Mystic Boots'
		$this.MapObjName         = 'mysticboots'
		$this.PurchasePrice      = 900
		$this.SellPrice          = 450
		$this.TargetStats        = @{
			[StatId]::Defense = 22
			[StatId]::MagicDefense = 35
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots that enhance magical aptitude.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
