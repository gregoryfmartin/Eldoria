using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEPROSPECTORBOOTS
#
###############################################################################

Class BEProspectorBoots : BEBoots {
	BEProspectorBoots() : base() {
		$this.Name               = 'Prospector Boots'
		$this.MapObjName         = 'prospectorboots'
		$this.PurchasePrice      = 230
		$this.SellPrice          = 115
		$this.TargetStats        = @{
			[StatId]::Defense = 7
			[StatId]::MagicDefense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots for mineral seekers.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
