using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BENECROMANCERPAULDRON
#
###############################################################################

Class BENecromancerPauldron : BEPauldron {
	BENecromancerPauldron() : base() {
		$this.Name               = 'Necromancer Pauldron'
		$this.MapObjName         = 'necromancerpauldron'
		$this.PurchasePrice      = 1450
		$this.SellPrice          = 725
		$this.TargetStats        = @{
			[StatId]::Defense = 29
			[StatId]::MagicDefense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Allows for manipulation of the undead, dark and chilling.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
