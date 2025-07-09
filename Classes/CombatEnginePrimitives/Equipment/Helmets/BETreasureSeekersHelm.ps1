using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE TREASURE SEEKER'S HELM
#
###############################################################################

Class BETreasureSeekersHelm : BEHelmet {
	BETreasureSeekersHelm() : base() {
		$this.Name               = 'Treasure Seeker''s Helm'
		$this.MapObjName         = 'treasureseekershelm'
		$this.PurchasePrice      = 220
		$this.SellPrice          = 110
		$this.TargetStats        = @{
			[StatId]::Defense = 5
			[StatId]::MagicDefense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm that occasionally gleams when hidden treasure is nearby.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
