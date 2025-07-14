using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECOTTONTUNIC
#
###############################################################################

Class BECottonTunic : BEArmor {
	BECottonTunic() : base() {
		$this.Name               = 'Cotton Tunic'
		$this.MapObjName         = 'cottontunic'
		$this.PurchasePrice      = 50
		$this.SellPrice          = 25
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A simple tunic made of soft cotton, comfortable for everyday wear.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
