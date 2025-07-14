using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BETEMPLARBOOTS
#
###############################################################################

Class BETemplarBoots : BEBoots {
	BETemplarBoots() : base() {
		$this.Name               = 'Templar Boots'
		$this.MapObjName         = 'templarboots'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{
			[StatId]::Defense = 40
			[StatId]::MagicDefense = 32
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Holy boots worn by zealous protectors.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
