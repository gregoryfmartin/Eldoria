using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESENATORBOOTS
#
###############################################################################

Class BESenatorBoots : BEBoots {
	BESenatorBoots() : base() {
		$this.Name               = 'Senator Boots'
		$this.MapObjName         = 'senatorboots'
		$this.PurchasePrice      = 450
		$this.SellPrice          = 225
		$this.TargetStats        = @{
			[StatId]::Defense = 18
			[StatId]::MagicDefense = 9
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of a governmental official.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
