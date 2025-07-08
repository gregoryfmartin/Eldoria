using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE STEEL HELMET
#
###############################################################################

Class BESteelHelmet : BEHelmet {
	BESteelHelmet() : base() {
		$this.Name               = 'Steel Helmet'
		$this.MapObjName         = 'steelhelmet'
		$this.PurchasePrice      = 280
		$this.SellPrice          = 140
		$this.TargetStats        = @{
			[StatId]::Defense = 8
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Forged from resilient steel, providing superior defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
