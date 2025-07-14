using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESHADOWSEMBRACEHELM
#
###############################################################################

Class BEShadowsEmbraceHelm : BEHelmet {
	BEShadowsEmbraceHelm() : base() {
		$this.Name               = 'Shadow''s Embrace Helm'
		$this.MapObjName         = 'shadowsembracehelm'
		$this.PurchasePrice      = 13000
		$this.SellPrice          = 6500
		$this.TargetStats        = @{
			[StatId]::Defense = 105
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm that embodies pure shadow, allowing the wearer to command darkness.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
