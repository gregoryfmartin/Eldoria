using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESPIRITDANCERSBLOUSE
#
###############################################################################

Class BESpiritDancersBlouse : BEArmor {
	BESpiritDancersBlouse() : base() {
		$this.Name               = 'Spirit Dancer''s Blouse'
		$this.MapObjName         = 'spiritdancersblouse'
		$this.PurchasePrice      = 120
		$this.SellPrice          = 60
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 7
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A light blouse that enhances agility and spiritual connection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
