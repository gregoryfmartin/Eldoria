using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BETEMPESTFISTS
#
###############################################################################

Class BETempestFists : BEGauntlets {
	BETempestFists() : base() {
		$this.Name               = 'Tempest Fists'
		$this.MapObjName         = 'tempestfists'
		$this.PurchasePrice      = 970
		$this.SellPrice          = 485
		$this.TargetStats        = @{
			[StatId]::Defense = 42
			[StatId]::MagicDefense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Fists crackling with the raw energy of a storm.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
