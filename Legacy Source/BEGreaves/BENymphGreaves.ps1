using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BENYMPHGREAVES
#
###############################################################################

Class BENymphGreaves : BEGreaves {
	BENymphGreaves() : base() {
		$this.Name               = 'Nymph Greaves'
		$this.MapObjName         = 'nymphgreaves'
		$this.PurchasePrice      = 650
		$this.SellPrice          = 325
		$this.TargetStats        = @{
			[StatId]::Defense = 22
			[StatId]::MagicDefense = 25
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves of a beautiful nature spirit.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
