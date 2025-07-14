using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGENERALBOOTS
#
###############################################################################

Class BEGeneralBoots : BEBoots {
	BEGeneralBoots() : base() {
		$this.Name               = 'General Boots'
		$this.MapObjName         = 'generalboots'
		$this.PurchasePrice      = 950
		$this.SellPrice          = 475
		$this.TargetStats        = @{
			[StatId]::Defense = 42
			[StatId]::MagicDefense = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots fit for a military general.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
