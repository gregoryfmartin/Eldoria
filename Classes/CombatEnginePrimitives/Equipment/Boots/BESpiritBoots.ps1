using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESPIRITBOOTS
#
###############################################################################

Class BESpiritBoots : BEBoots {
	BESpiritBoots() : base() {
		$this.Name               = 'Spirit Boots'
		$this.MapObjName         = 'spiritboots'
		$this.PurchasePrice      = 1150
		$this.SellPrice          = 575
		$this.TargetStats        = @{
			[StatId]::Defense = 40
			[StatId]::MagicDefense = 35
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots that resonate with spiritual energy.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
