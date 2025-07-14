using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGROTTOBOOTS
#
###############################################################################

Class BEGrottoBoots : BEBoots {
	BEGrottoBoots() : base() {
		$this.Name               = 'Grotto Boots'
		$this.MapObjName         = 'grottoboots'
		$this.PurchasePrice      = 370
		$this.SellPrice          = 185
		$this.TargetStats        = @{
			[StatId]::Defense = 13
			[StatId]::MagicDefense = 8
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots for small cave systems.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
