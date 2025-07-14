using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEMASTERBOOTS
#
###############################################################################

Class BEMasterBoots : BEBoots {
	BEMasterBoots() : base() {
		$this.Name               = 'Master Boots'
		$this.MapObjName         = 'masterboots'
		$this.PurchasePrice      = 950
		$this.SellPrice          = 475
		$this.TargetStats        = @{
			[StatId]::Defense = 37
			[StatId]::MagicDefense = 22
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots worn by true masters of their craft.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
