using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEBEASTMASTERSTUNIC
#
###############################################################################

Class BEBeastmastersTunic : BEArmor {
	BEBeastmastersTunic() : base() {
		$this.Name               = 'Beastmaster''s Tunic'
		$this.MapObjName         = 'beastmasterstunic'
		$this.PurchasePrice      = 230
		$this.SellPrice          = 115
		$this.TargetStats        = @{
			[StatId]::Defense = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A tunic made from tough animal hides, enhances communication with beasts.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
