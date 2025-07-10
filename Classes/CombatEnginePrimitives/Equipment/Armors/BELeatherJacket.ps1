using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BELEATHERJACKET
#
###############################################################################

Class BELeatherJacket : BEArmor {
	BELeatherJacket() : base() {
		$this.Name               = 'Leather Jacket'
		$this.MapObjName         = 'leatherjacket'
		$this.PurchasePrice      = 180
		$this.SellPrice          = 90
		$this.TargetStats        = @{
			[StatId]::Defense = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A stylish leather jacket offering modest defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
