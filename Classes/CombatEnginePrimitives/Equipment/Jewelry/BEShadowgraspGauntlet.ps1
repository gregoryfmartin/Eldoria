using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESHADOWGRASPGAUNTLET
#
###############################################################################

Class BEShadowgraspGauntlet : BEJewelry {
	BEShadowgraspGauntlet() : base() {
		$this.Name               = 'Shadowgrasp Gauntlet'
		$this.MapObjName         = 'shadowgraspgauntlet'
		$this.PurchasePrice      = 1200
		$this.SellPrice          = 600
		$this.TargetStats        = @{
			[StatId]::Attack = 1
			[StatId]::Defense = 1
			[StatId]::Speed = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A gauntlet designed to blend into shadows, enhancing stealth.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK  +$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Male
	}
}
