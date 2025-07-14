using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEKOBOLDGREAVES
#
###############################################################################

Class BEKoboldGreaves : BEGreaves {
	BEKoboldGreaves() : base() {
		$this.Name               = 'Kobold Greaves'
		$this.MapObjName         = 'koboldgreaves'
		$this.PurchasePrice      = 90
		$this.SellPrice          = 45
		$this.TargetStats        = @{
			[StatId]::Defense = 3
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Crude greaves of kobolds.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
