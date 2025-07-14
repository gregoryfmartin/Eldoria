using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESUMMONERSBINDINGCIRCLE
#
###############################################################################

Class BESummonersBindingCircle : BEJewelry {
	BESummonersBindingCircle() : base() {
		$this.Name               = 'Summoner''s Binding Circle'
		$this.MapObjName         = 'summonersbindingcircle'
		$this.PurchasePrice      = 1800
		$this.SellPrice          = 900
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A miniature binding circle, for controlling summoned beings.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
