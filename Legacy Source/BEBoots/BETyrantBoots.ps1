using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BETYRANTBOOTS
#
###############################################################################

Class BETyrantBoots : BEBoots {
	BETyrantBoots() : base() {
		$this.Name               = 'Tyrant Boots'
		$this.MapObjName         = 'tyrantboots'
		$this.PurchasePrice      = 950
		$this.SellPrice          = 475
		$this.TargetStats        = @{
			[StatId]::Defense = 39
			[StatId]::MagicDefense = 13
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of an oppressive ruler.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
