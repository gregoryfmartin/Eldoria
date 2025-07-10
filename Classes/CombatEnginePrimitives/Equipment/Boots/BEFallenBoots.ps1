using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEFALLENBOOTS
#
###############################################################################

Class BEFallenBoots : BEBoots {
	BEFallenBoots() : base() {
		$this.Name               = 'Fallen Boots'
		$this.MapObjName         = 'fallenboots'
		$this.PurchasePrice      = 950
		$this.SellPrice          = 475
		$this.TargetStats        = @{
			[StatId]::Defense = 37
			[StatId]::MagicDefense = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of a corrupted warrior.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
