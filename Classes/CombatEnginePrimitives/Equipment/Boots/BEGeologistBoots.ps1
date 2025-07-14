using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGEOLOGISTBOOTS
#
###############################################################################

Class BEGeologistBoots : BEBoots {
	BEGeologistBoots() : base() {
		$this.Name               = 'Geologist Boots'
		$this.MapObjName         = 'geologistboots'
		$this.PurchasePrice      = 420
		$this.SellPrice          = 210
		$this.TargetStats        = @{
			[StatId]::Defense = 16
			[StatId]::MagicDefense = 9
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots for earth scientists.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
