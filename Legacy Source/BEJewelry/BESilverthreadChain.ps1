using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESILVERTHREADCHAIN
#
###############################################################################

Class BESilverthreadChain : BEJewelry {
	BESilverthreadChain() : base() {
		$this.Name               = 'Silverthread Chain'
		$this.MapObjName         = 'silverthreadchain'
		$this.PurchasePrice      = 200
		$this.SellPrice          = 100
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 1
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A finely woven silver chain, for subtle magic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
