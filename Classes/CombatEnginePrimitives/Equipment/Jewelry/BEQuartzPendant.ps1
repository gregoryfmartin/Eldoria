using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEQUARTZPENDANT
#
###############################################################################

Class BEQuartzPendant : BEJewelry {
	BEQuartzPendant() : base() {
		$this.Name               = 'Quartz Pendant'
		$this.MapObjName         = 'quartzpendant'
		$this.PurchasePrice      = 300
		$this.SellPrice          = 150
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 1
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A clear quartz pendant, amplifying magical energies.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
