using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEHUNTERKILLERBOOTS
#
###############################################################################

Class BEHunterKillerBoots : BEBoots {
	BEHunterKillerBoots() : base() {
		$this.Name               = 'Hunter Killer Boots'
		$this.MapObjName         = 'hunterkillerboots'
		$this.PurchasePrice      = 850
		$this.SellPrice          = 425
		$this.TargetStats        = @{
			[StatId]::Defense = 32
			[StatId]::MagicDefense = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots designed for tracking and eliminating targets.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
