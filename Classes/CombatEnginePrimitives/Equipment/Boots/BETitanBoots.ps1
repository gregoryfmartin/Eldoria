using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BETITANBOOTS
#
###############################################################################

Class BETitanBoots : BEBoots {
	BETitanBoots() : base() {
		$this.Name               = 'Titan Boots'
		$this.MapObjName         = 'titanboots'
		$this.PurchasePrice      = 1800
		$this.SellPrice          = 900
		$this.TargetStats        = @{
			[StatId]::Defense = 67
			[StatId]::MagicDefense = 35
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of legendary titans, immensely strong.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
