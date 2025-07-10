using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEFROSTWEAVEROBE
#
###############################################################################

Class BEFrostweaveRobe : BEArmor {
	BEFrostweaveRobe() : base() {
		$this.Name               = 'Frostweave Robe'
		$this.MapObjName         = 'frostweaverobe'
		$this.PurchasePrice      = 780
		$this.SellPrice          = 390
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 22
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robe woven from icy fibers, providing cold resistance.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
