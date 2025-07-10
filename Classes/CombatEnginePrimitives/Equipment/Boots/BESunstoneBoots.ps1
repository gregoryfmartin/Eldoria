using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESUNSTONEBOOTS
#
###############################################################################

Class BESunstoneBoots : BEBoots {
	BESunstoneBoots() : base() {
		$this.Name               = 'Sunstone Boots'
		$this.MapObjName         = 'sunstoneboots'
		$this.PurchasePrice      = 1250
		$this.SellPrice          = 625
		$this.TargetStats        = @{
			[StatId]::Defense = 47
			[StatId]::MagicDefense = 30
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots that shimmer with solar energy.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
