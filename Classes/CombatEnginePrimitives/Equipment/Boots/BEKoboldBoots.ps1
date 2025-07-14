using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEKOBOLDBOOTS
#
###############################################################################

Class BEKoboldBoots : BEBoots {
	BEKoboldBoots() : base() {
		$this.Name               = 'Kobold Boots'
		$this.MapObjName         = 'koboldboots'
		$this.PurchasePrice      = 80
		$this.SellPrice          = 40
		$this.TargetStats        = @{
			[StatId]::Defense = 2
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Crude boots of kobolds.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
