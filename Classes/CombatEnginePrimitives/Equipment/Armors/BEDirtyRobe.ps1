using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDIRTYROBE
#
###############################################################################

Class BEDirtyRobe : BEArmor {
	BEDirtyRobe() : base() {
		$this.Name               = 'Dirty Robe'
		$this.MapObjName         = 'dirtyrobe'
		$this.PurchasePrice      = 70
		$this.SellPrice          = 35
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 8
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A grimy robe, suitable for beggars or desperate mages.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
