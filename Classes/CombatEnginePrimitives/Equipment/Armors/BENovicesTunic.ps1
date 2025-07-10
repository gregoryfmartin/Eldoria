using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BENOVICESTUNIC
#
###############################################################################

Class BENovicesTunic : BEArmor {
	BENovicesTunic() : base() {
		$this.Name               = 'Novice''s Tunic'
		$this.MapObjName         = 'novicestunic'
		$this.PurchasePrice      = 45
		$this.SellPrice          = 23
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A simple tunic worn by those beginning their adventure.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Unisex
	}
}
