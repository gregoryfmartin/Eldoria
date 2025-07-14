using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BETRAVELERSCLOAK
#
###############################################################################

Class BETravelersCloak : BEArmor {
	BETravelersCloak() : base() {
		$this.Name               = 'Traveler''s Cloak'
		$this.MapObjName         = 'travelerscloak'
		$this.PurchasePrice      = 90
		$this.SellPrice          = 45
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A multi-purpose cloak that can be worn like a tunic.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Unisex
	}
}
