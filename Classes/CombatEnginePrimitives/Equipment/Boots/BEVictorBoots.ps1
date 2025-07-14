using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEVICTORBOOTS
#
###############################################################################

Class BEVictorBoots : BEBoots {
	BEVictorBoots() : base() {
		$this.Name               = 'Victor Boots'
		$this.MapObjName         = 'victorboots'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{
			[StatId]::Defense = 43
			[StatId]::MagicDefense = 22
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots worn by those who claim victory.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
