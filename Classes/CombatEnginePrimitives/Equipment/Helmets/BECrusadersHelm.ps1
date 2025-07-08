using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE CRUSADERS HELM
#
###############################################################################

Class BECrusadersHelm : BEHelmet {
	BECrusadersHelm() : base() {
		$this.Name               = 'Crusader''s Helm'
		$this.MapObjName         = 'crusadershelm'
		$this.PurchasePrice      = 1600
		$this.SellPrice          = 800
		$this.TargetStats        = @{
			[StatId]::Defense = 14
			[StatId]::MagicDefense = 7
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A cross-emblazoned helm worn by crusaders, symbolizing faith and might.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
