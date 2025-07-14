using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEPHANTOMGREAVES
#
###############################################################################

Class BEPhantomGreaves : BEGreaves {
	BEPhantomGreaves() : base() {
		$this.Name               = 'Phantom Greaves'
		$this.MapObjName         = 'phantomgreaves'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{
			[StatId]::Defense = 30
			[StatId]::MagicDefense = 40
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves of an elusive spirit.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
