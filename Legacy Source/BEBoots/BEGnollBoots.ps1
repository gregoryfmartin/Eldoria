using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGNOLLBOOTS
#
###############################################################################

Class BEGnollBoots : BEBoots {
	BEGnollBoots() : base() {
		$this.Name               = 'Gnoll Boots'
		$this.MapObjName         = 'gnollboots'
		$this.PurchasePrice      = 100
		$this.SellPrice          = 50
		$this.TargetStats        = @{
			[StatId]::Defense = 4
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Rough boots of hyena folk.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
