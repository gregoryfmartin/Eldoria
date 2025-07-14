using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEFAITHGREAVES
#
###############################################################################

Class BEFaithGreaves : BEGreaves {
	BEFaithGreaves() : base() {
		$this.Name               = 'Faith Greaves'
		$this.MapObjName         = 'faithgreaves'
		$this.PurchasePrice      = 700
		$this.SellPrice          = 350
		$this.TargetStats        = @{
			[StatId]::Defense = 25
			[StatId]::MagicDefense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves of unwavering belief.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
