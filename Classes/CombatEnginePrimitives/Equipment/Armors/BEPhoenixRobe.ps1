using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEPHOENIXROBE
#
###############################################################################

Class BEPhoenixRobe : BEArmor {
	BEPhoenixRobe() : base() {
		$this.Name               = 'Phoenix Robe'
		$this.MapObjName         = 'phoenixrobe'
		$this.PurchasePrice      = 1600
		$this.SellPrice          = 800
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 30
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A vibrant robe said to grant its wearer renewed vigor.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
