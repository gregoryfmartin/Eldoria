using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEWOOLENTUNIC
#
###############################################################################

Class BEWoolenTunic : BEArmor {
	BEWoolenTunic() : base() {
		$this.Name               = 'Woolen Tunic'
		$this.MapObjName         = 'woolentunic'
		$this.PurchasePrice      = 60
		$this.SellPrice          = 30
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A warm tunic, ideal for colder climates.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Unisex
	}
}
