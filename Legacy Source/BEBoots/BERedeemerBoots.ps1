using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEREDEEMERBOOTS
#
###############################################################################

Class BERedeemerBoots : BEBoots {
	BERedeemerBoots() : base() {
		$this.Name               = 'Redeemer Boots'
		$this.MapObjName         = 'redeemerboots'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{
			[StatId]::Defense = 42
			[StatId]::MagicDefense = 22
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots that bring salvation.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
