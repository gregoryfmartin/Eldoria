using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESORCERERSTUNIC
#
###############################################################################

Class BESorcerersTunic : BEArmor {
	BESorcerersTunic() : base() {
		$this.Name               = 'Sorcerer''s Tunic'
		$this.MapObjName         = 'sorcererstunic'
		$this.PurchasePrice      = 170
		$this.SellPrice          = 85
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 12
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A simple tunic, often worn under a robe, with minor magical properties.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
