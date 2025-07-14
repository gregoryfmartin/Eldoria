using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BETRIUMPHBOOTS
#
###############################################################################

Class BETriumphBoots : BEBoots {
	BETriumphBoots() : base() {
		$this.Name               = 'Triumph Boots'
		$this.MapObjName         = 'triumphboots'
		$this.PurchasePrice      = 1200
		$this.SellPrice          = 600
		$this.TargetStats        = @{
			[StatId]::Defense = 47
			[StatId]::MagicDefense = 25
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots signifying great success.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
