using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEEMPERORBOOTS
#
###############################################################################

Class BEEmperorBoots : BEBoots {
	BEEmperorBoots() : base() {
		$this.Name               = 'Emperor Boots'
		$this.MapObjName         = 'emperorboots'
		$this.PurchasePrice      = 1500
		$this.SellPrice          = 750
		$this.TargetStats        = @{
			[StatId]::Defense = 55
			[StatId]::MagicDefense = 30
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of an undisputed ruler.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
