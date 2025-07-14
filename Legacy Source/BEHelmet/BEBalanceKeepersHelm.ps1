using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEBALANCEKEEPERSHELM
#
###############################################################################

Class BEBalanceKeepersHelm : BEHelmet {
	BEBalanceKeepersHelm() : base() {
		$this.Name               = 'Balance Keeper''s Helm'
		$this.MapObjName         = 'balancekeepershelm'
		$this.PurchasePrice      = 9500
		$this.SellPrice          = 4750
		$this.TargetStats        = @{
			[StatId]::Defense = 55
			[StatId]::MagicDefense = 85
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm that maintains the balance between light and darkness, good and evil.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
