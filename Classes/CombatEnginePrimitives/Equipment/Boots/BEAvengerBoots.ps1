using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEAVENGERBOOTS
#
###############################################################################

Class BEAvengerBoots : BEBoots {
	BEAvengerBoots() : base() {
		$this.Name               = 'Avenger Boots'
		$this.MapObjName         = 'avengerboots'
		$this.PurchasePrice      = 950
		$this.SellPrice          = 475
		$this.TargetStats        = @{
			[StatId]::Defense = 39
			[StatId]::MagicDefense = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of righteous vengeance.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
