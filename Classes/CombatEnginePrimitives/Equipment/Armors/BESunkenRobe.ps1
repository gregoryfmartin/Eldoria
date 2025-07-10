using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESUNKENROBE
#
###############################################################################

Class BESunkenRobe : BEArmor {
	BESunkenRobe() : base() {
		$this.Name               = 'Sunken Robe'
		$this.MapObjName         = 'sunkenrobe'
		$this.PurchasePrice      = 1200
		$this.SellPrice          = 600
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 30
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robe recovered from deep sea ruins, still damp but enchanted.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
