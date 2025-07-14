using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEVANQUISHERBOOTS
#
###############################################################################

Class BEVanquisherBoots : BEBoots {
	BEVanquisherBoots() : base() {
		$this.Name               = 'Vanquisher Boots'
		$this.MapObjName         = 'vanquisherboots'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{
			[StatId]::Defense = 40
			[StatId]::MagicDefense = 22
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of one who utterly defeats their foes.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
