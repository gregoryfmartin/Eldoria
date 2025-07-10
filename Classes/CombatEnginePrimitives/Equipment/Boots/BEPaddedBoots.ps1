using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEPADDEDBOOTS
#
###############################################################################

Class BEPaddedBoots : BEBoots {
	BEPaddedBoots() : base() {
		$this.Name               = 'Padded Boots'
		$this.MapObjName         = 'paddedboots'
		$this.PurchasePrice      = 100
		$this.SellPrice          = 50
		$this.TargetStats        = @{
			[StatId]::Defense = 4
			[StatId]::MagicDefense = 2
			[StatId]::Speed = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Lightly padded boots for comfortable movement.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Unisex
	}
}
