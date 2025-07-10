using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEPHANTOMBOOTS
#
###############################################################################

Class BEPhantomBoots : BEBoots {
	BEPhantomBoots() : base() {
		$this.Name               = 'Phantom Boots'
		$this.MapObjName         = 'phantomboots'
		$this.PurchasePrice      = 950
		$this.SellPrice          = 475
		$this.TargetStats        = @{
			[StatId]::Defense = 27
			[StatId]::MagicDefense = 35
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of an elusive spirit.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
