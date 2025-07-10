using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEPUNISHERBOOTS
#
###############################################################################

Class BEPunisherBoots : BEBoots {
	BEPunisherBoots() : base() {
		$this.Name               = 'Punisher Boots'
		$this.MapObjName         = 'punisherboots'
		$this.PurchasePrice      = 900
		$this.SellPrice          = 450
		$this.TargetStats        = @{
			[StatId]::Defense = 37
			[StatId]::MagicDefense = 16
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of relentless retribution.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
