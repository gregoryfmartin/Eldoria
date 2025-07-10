using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESAGEBOOTS
#
###############################################################################

Class BESageBoots : BEBoots {
	BESageBoots() : base() {
		$this.Name               = 'Sage Boots'
		$this.MapObjName         = 'sageboots'
		$this.PurchasePrice      = 850
		$this.SellPrice          = 425
		$this.TargetStats        = @{
			[StatId]::Defense = 25
			[StatId]::MagicDefense = 37
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of profound wisdom.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
