using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE STONE GOLEM HELM
#
###############################################################################

Class BEStoneGolemHelm : BEHelmet {
	BEStoneGolemHelm() : base() {
		$this.Name               = 'Stone Golem Helm'
		$this.MapObjName         = 'stonegolemhelm'
		$this.PurchasePrice      = 1600
		$this.SellPrice          = 800
		$this.TargetStats        = @{
			[StatId]::Defense = 17
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A heavy helm made from golem stone, offering robust defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
