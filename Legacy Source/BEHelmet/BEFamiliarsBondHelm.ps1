using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEFAMILIARSBONDHELM
#
###############################################################################

Class BEFamiliarsBondHelm : BEHelmet {
	BEFamiliarsBondHelm() : base() {
		$this.Name               = 'Familiar''s Bond Helm'
		$this.MapObjName         = 'familiarsbondhelm'
		$this.PurchasePrice      = 1200
		$this.SellPrice          = 600
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 12
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm that strengthens the bond with a magical familiar.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
