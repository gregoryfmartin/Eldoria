using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEHEROICBOOTS
#
###############################################################################

Class BEHeroicBoots : BEBoots {
	BEHeroicBoots() : base() {
		$this.Name               = 'Heroic Boots'
		$this.MapObjName         = 'heroicboots'
		$this.PurchasePrice      = 1200
		$this.SellPrice          = 600
		$this.TargetStats        = @{
			[StatId]::Defense = 45
			[StatId]::MagicDefense = 22
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots worn by legendary heroes.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
