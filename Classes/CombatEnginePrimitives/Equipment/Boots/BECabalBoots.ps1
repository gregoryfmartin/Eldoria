using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECABALBOOTS
#
###############################################################################

Class BECabalBoots : BEBoots {
	BECabalBoots() : base() {
		$this.Name               = 'Cabal Boots'
		$this.MapObjName         = 'cabalboots'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{
			[StatId]::Defense = 39
			[StatId]::MagicDefense = 32
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of a secret magical society.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
