using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGIANTBOOTS
#
###############################################################################

Class BEGiantBoots : BEBoots {
	BEGiantBoots() : base() {
		$this.Name               = 'Giant Boots'
		$this.MapObjName         = 'giantboots'
		$this.PurchasePrice      = 650
		$this.SellPrice          = 325
		$this.TargetStats        = @{
			[StatId]::Defense = 35
			[StatId]::MagicDefense = 7
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots sized for colossal beings.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
