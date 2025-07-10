using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDRUIDESSSROBE
#
###############################################################################

Class BEDruidesssRobe : BEArmor {
	BEDruidesssRobe() : base() {
		$this.Name               = 'Druidess''s Robe'
		$this.MapObjName         = 'druidesssrobe'
		$this.PurchasePrice      = 650
		$this.SellPrice          = 325
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robe made of natural fibers, attuned to nature''s magic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
