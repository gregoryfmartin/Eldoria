using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEMITHRILCHAINCOIF
#
###############################################################################

Class BEMithrilChainCoif : BEHelmet {
	BEMithrilChainCoif() : base() {
		$this.Name               = 'Mithril Chain Coif'
		$this.MapObjName         = 'mithrilchaincoif'
		$this.PurchasePrice      = 550
		$this.SellPrice          = 275
		$this.TargetStats        = @{
			[StatId]::Defense = 10
			[StatId]::MagicDefense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A light and flexible coif made of mithril chain, offering good protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
