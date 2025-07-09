using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE GOLEM COMMANDER'S HELM
#
###############################################################################

Class BEGolemCommandersHelm : BEHelmet {
	BEGolemCommandersHelm() : base() {
		$this.Name               = 'Golem Commander''s Helm'
		$this.MapObjName         = 'golemcommandershelm'
		$this.PurchasePrice      = 2000
		$this.SellPrice          = 1000
		$this.TargetStats        = @{
			[StatId]::Defense = 10
			[StatId]::MagicDefense = 19
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm that allows direct mental control over nearby golems.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
