using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE CELESTIAL DIADEM
#
###############################################################################

Class BECelestialDiadem : BEHelmet {
	BECelestialDiadem() : base() {
		$this.Name               = 'Celestial Diadem'
		$this.MapObjName         = 'celestialdiadem'
		$this.PurchasePrice      = 3100
		$this.SellPrice          = 1550
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 26
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A diadem adorned with fragments of starlight, radiating divine protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
