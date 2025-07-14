using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGRANDMASTERBOOTS
#
###############################################################################

Class BEGrandmasterBoots : BEBoots {
	BEGrandmasterBoots() : base() {
		$this.Name               = 'Grandmaster Boots'
		$this.MapObjName         = 'grandmasterboots'
		$this.PurchasePrice      = 1400
		$this.SellPrice          = 700
		$this.TargetStats        = @{
			[StatId]::Defense = 50
			[StatId]::MagicDefense = 30
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of unparalleled skill and defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
