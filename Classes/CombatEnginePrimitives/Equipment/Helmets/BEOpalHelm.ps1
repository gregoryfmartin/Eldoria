using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEOPALHELM
#
###############################################################################

Class BEOpalHelm : BEHelmet {
	BEOpalHelm() : base() {
		$this.Name               = 'Opal Helm'
		$this.MapObjName         = 'opalhelm'
		$this.PurchasePrice      = 1400
		$this.SellPrice          = 700
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 14
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A shimmering helm with an opal, granting minor illusionary abilities.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
