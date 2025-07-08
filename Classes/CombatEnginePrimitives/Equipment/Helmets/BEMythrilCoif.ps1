using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE MYTHRIL COIF
#
###############################################################################

Class BEMythrilCoif : BEHelmet {
	BEMythrilCoif() : base() {
		$this.Name               = 'Mythril Coif'
		$this.MapObjName         = 'mythrilcoif'
		$this.PurchasePrice      = 600
		$this.SellPrice          = 300
		$this.TargetStats        = @{
			[StatId]::Defense = 12
			[StatId]::MagicDefense = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A lightweight and strong coif made from mythril, favored by adventurers.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
