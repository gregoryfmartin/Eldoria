using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESPRITEBOOTS
#
###############################################################################

Class BESpriteBoots : BEBoots {
	BESpriteBoots() : base() {
		$this.Name               = 'Sprite Boots'
		$this.MapObjName         = 'spriteboots'
		$this.PurchasePrice      = 150
		$this.SellPrice          = 75
		$this.TargetStats        = @{
			[StatId]::Defense = 5
			[StatId]::MagicDefense = 9
			[StatId]::Speed = 16
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Nimble boots of a playful spirit.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Female
	}
}
