using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEINFERNALBOOTS
#
###############################################################################

Class BEInfernalBoots : BEBoots {
	BEInfernalBoots() : base() {
		$this.Name               = 'Infernal Boots'
		$this.MapObjName         = 'infernalboots'
		$this.PurchasePrice      = 1200
		$this.SellPrice          = 600
		$this.TargetStats        = @{
			[StatId]::Defense = 47
			[StatId]::MagicDefense = 25
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots forged in the fires of hell.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
