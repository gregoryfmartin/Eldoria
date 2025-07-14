using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESPRITEGREAVES
#
###############################################################################

Class BESpriteGreaves : BEGreaves {
	BESpriteGreaves() : base() {
		$this.Name               = 'Sprite Greaves'
		$this.MapObjName         = 'spritegreaves'
		$this.PurchasePrice      = 170
		$this.SellPrice          = 85
		$this.TargetStats        = @{
			[StatId]::Defense = 6
			[StatId]::MagicDefense = 10
			[StatId]::Speed = 13
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Nimble greaves of a playful spirit.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Female
	}
}
