using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BERIGHTEOUSBOOTS
#
###############################################################################

Class BERighteousBoots : BEBoots {
	BERighteousBoots() : base() {
		$this.Name               = 'Righteous Boots'
		$this.MapObjName         = 'righteousboots'
		$this.PurchasePrice      = 900
		$this.SellPrice          = 450
		$this.TargetStats        = @{
			[StatId]::Defense = 35
			[StatId]::MagicDefense = 16
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of moral rectitude.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
