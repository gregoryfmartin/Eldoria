using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGOLEMCOREFRAGMENT
#
###############################################################################

Class BEGolemCoreFragment : BEJewelry {
	BEGolemCoreFragment() : base() {
		$this.Name               = 'Golem Core Fragment'
		$this.MapObjName         = 'golemcorefragment'
		$this.PurchasePrice      = 1500
		$this.SellPrice          = 750
		$this.TargetStats        = @{
			[StatId]::Defense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A piece of a golem''s core, slightly humming.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
