using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEARCHANGELBOOTS
#
###############################################################################

Class BEArchangelBoots : BEBoots {
	BEArchangelBoots() : base() {
		$this.Name               = 'Archangel Boots'
		$this.MapObjName         = 'archangelboots'
		$this.PurchasePrice      = 1700
		$this.SellPrice          = 850
		$this.TargetStats        = @{
			[StatId]::Defense = 65
			[StatId]::MagicDefense = 45
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of the highest order of angels.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
