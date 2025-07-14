using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEWYVERNGREAVES
#
###############################################################################

Class BEWyvernGreaves : BEGreaves {
	BEWyvernGreaves() : base() {
		$this.Name               = 'Wyvern Greaves'
		$this.MapObjName         = 'wyverngreaves'
		$this.PurchasePrice      = 1400
		$this.SellPrice          = 700
		$this.TargetStats        = @{
			[StatId]::Defense = 50
			[StatId]::MagicDefense = 30
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves crafted from wyvern scales.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
