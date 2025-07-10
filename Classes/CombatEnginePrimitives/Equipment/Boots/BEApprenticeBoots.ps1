using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEAPPRENTICEBOOTS
#
###############################################################################

Class BEApprenticeBoots : BEBoots {
	BEApprenticeBoots() : base() {
		$this.Name               = 'Apprentice Boots'
		$this.MapObjName         = 'apprenticeboots'
		$this.PurchasePrice      = 60
		$this.SellPrice          = 30
		$this.TargetStats        = @{
			[StatId]::Defense = 2
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Basic boots for aspiring adventurers.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
