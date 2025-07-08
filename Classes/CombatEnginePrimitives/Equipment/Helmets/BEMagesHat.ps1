using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE MAGES HAT
#
###############################################################################

Class BEMagesHat : BEHelmet {
	BEMagesHat() : base() {
		$this.Name               = 'Mage''s Hat'
		$this.MapObjName         = 'mageshat'
		$this.PurchasePrice      = 90
		$this.SellPrice          = 45
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 7
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A pointed hat worn by mages, rumored to amplify magical energies.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
