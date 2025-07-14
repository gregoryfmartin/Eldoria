using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEBEASTBOOTS
#
###############################################################################

Class BEBeastBoots : BEBoots {
	BEBeastBoots() : base() {
		$this.Name               = 'Beast Boots'
		$this.MapObjName         = 'beastboots'
		$this.PurchasePrice      = 550
		$this.SellPrice          = 275
		$this.TargetStats        = @{
			[StatId]::Defense = 25
			[StatId]::MagicDefense = 9
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots made from monstrous beast hides.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
