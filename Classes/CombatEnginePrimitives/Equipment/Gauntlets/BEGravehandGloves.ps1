using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGRAVEHANDGLOVES
#
###############################################################################

Class BEGravehandGloves : BEGauntlets {
	BEGravehandGloves() : base() {
		$this.Name               = 'Gravehand Gloves'
		$this.MapObjName         = 'gravehandgloves'
		$this.PurchasePrice      = 770
		$this.SellPrice          = 385
		$this.TargetStats        = @{
			[StatId]::Defense = 10
			[StatId]::MagicDefense = 30
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gloves that chill to the touch, connected to the underworld.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
