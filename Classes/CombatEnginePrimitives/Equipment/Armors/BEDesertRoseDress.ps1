using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDESERTROSEDRESS
#
###############################################################################

Class BEDesertRoseDress : BEArmor {
	BEDesertRoseDress() : base() {
		$this.Name               = 'Desert Rose Dress'
		$this.MapObjName         = 'desertrosedress'
		$this.PurchasePrice      = 180
		$this.SellPrice          = 90
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A light, airy dress, comfortable in hot climates, with minor fire resistance.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
