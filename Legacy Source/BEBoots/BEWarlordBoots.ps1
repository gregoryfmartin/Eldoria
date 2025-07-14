using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEWARLORDBOOTS
#
###############################################################################

Class BEWarlordBoots : BEBoots {
	BEWarlordBoots() : base() {
		$this.Name               = 'Warlord Boots'
		$this.MapObjName         = 'warlordboots'
		$this.PurchasePrice      = 1300
		$this.SellPrice          = 650
		$this.TargetStats        = @{
			[StatId]::Defense = 53
			[StatId]::MagicDefense = 29
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of a powerful military leader.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
