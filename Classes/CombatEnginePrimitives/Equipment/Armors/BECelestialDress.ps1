using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECELESTIALDRESS
#
###############################################################################

Class BECelestialDress : BEArmor {
	BECelestialDress() : base() {
		$this.Name               = 'Celestial Dress'
		$this.MapObjName         = 'celestialdress'
		$this.PurchasePrice      = 600
		$this.SellPrice          = 300
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 9
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A dress adorned with celestial patterns, granting minor magical resistance.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
