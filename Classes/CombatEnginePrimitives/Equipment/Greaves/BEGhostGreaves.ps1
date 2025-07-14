using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGHOSTGREAVES
#
###############################################################################

Class BEGhostGreaves : BEGreaves {
	BEGhostGreaves() : base() {
		$this.Name               = 'Ghost Greaves'
		$this.MapObjName         = 'ghostgreaves'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{
			[StatId]::Defense = 30
			[StatId]::MagicDefense = 45
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Ethereal greaves, difficult to hit.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
