using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECELESTIALSORCERESSGOWN
#
###############################################################################

Class BECelestialSorceressGown : BEArmor {
	BECelestialSorceressGown() : base() {
		$this.Name               = 'Celestial Sorceress Gown'
		$this.MapObjName         = 'celestialsorceressgown'
		$this.PurchasePrice      = 2300
		$this.SellPrice          = 1150
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 44
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A magnificent gown adorned with celestial patterns, immensely powerful for magic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
