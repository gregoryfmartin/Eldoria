using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEPRIESTESSSBLESSINGBEAD
#
###############################################################################

Class BEPriestesssBlessingBead : BEJewelry {
	BEPriestesssBlessingBead() : base() {
		$this.Name               = 'Priestess''s Blessing Bead'
		$this.MapObjName         = 'priestesssblessingbead'
		$this.PurchasePrice      = 1350
		$this.SellPrice          = 675
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A single bead imbued with divine blessing.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
