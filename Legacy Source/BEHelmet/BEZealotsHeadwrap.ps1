using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEZEALOTSHEADWRAP
#
###############################################################################

Class BEZealotsHeadwrap : BEHelmet {
	BEZealotsHeadwrap() : base() {
		$this.Name               = 'Zealot''s Headwrap'
		$this.MapObjName         = 'zealotsheadwrap'
		$this.PurchasePrice      = 90
		$this.SellPrice          = 45
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A simple headwrap worn by zealots, signifying their fervent devotion.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
