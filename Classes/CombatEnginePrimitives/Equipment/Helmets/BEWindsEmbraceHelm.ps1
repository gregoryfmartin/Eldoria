using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEWINDSEMBRACEHELM
#
###############################################################################

Class BEWindsEmbraceHelm : BEHelmet {
	BEWindsEmbraceHelm() : base() {
		$this.Name               = 'Wind''s Embrace Helm'
		$this.MapObjName         = 'windsembracehelm'
		$this.PurchasePrice      = 1600
		$this.SellPrice          = 800
		$this.TargetStats        = @{
			[StatId]::Defense = 10
			[StatId]::MagicDefense = 8
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A light helm that allows the wearer to move with the swiftness of wind.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
