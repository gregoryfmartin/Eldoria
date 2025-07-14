using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECRIMSONROBE
#
###############################################################################

Class BECrimsonRobe : BEArmor {
	BECrimsonRobe() : base() {
		$this.Name               = 'Crimson Robe'
		$this.MapObjName         = 'crimsonrobe'
		$this.PurchasePrice      = 1300
		$this.SellPrice          = 650
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 30
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A vivid red robe, associated with powerful fire mages.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
