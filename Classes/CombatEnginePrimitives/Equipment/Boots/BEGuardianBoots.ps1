using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGUARDIANBOOTS
#
###############################################################################

Class BEGuardianBoots : BEBoots {
	BEGuardianBoots() : base() {
		$this.Name               = 'Guardian Boots'
		$this.MapObjName         = 'guardianboots'
		$this.PurchasePrice      = 800
		$this.SellPrice          = 400
		$this.TargetStats        = @{
			[StatId]::Defense = 38
			[StatId]::MagicDefense = 16
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots designed to protect the wearer at all costs.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
