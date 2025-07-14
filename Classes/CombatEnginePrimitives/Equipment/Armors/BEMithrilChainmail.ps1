using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEMITHRILCHAINMAIL
#
###############################################################################

Class BEMithrilChainmail : BEArmor {
	BEMithrilChainmail() : base() {
		$this.Name               = 'Mithril Chainmail'
		$this.MapObjName         = 'mithrilchainmail'
		$this.PurchasePrice      = 800
		$this.SellPrice          = 400
		$this.TargetStats        = @{
			[StatId]::Defense = 10
			[StatId]::MagicDefense = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Lightweight yet incredibly strong chainmail.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
