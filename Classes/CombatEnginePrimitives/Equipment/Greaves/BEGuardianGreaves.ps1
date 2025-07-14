using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGUARDIANGREAVES
#
###############################################################################

Class BEGuardianGreaves : BEGreaves {
	BEGuardianGreaves() : base() {
		$this.Name               = 'Guardian Greaves'
		$this.MapObjName         = 'guardiangreaves'
		$this.PurchasePrice      = 850
		$this.SellPrice          = 425
		$this.TargetStats        = @{
			[StatId]::Defense = 42
			[StatId]::MagicDefense = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves designed to protect the wearer at all costs.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
