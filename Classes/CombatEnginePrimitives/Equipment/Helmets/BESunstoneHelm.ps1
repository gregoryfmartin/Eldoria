using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESUNSTONEHELM
#
###############################################################################

Class BESunstoneHelm : BEHelmet {
	BESunstoneHelm() : base() {
		$this.Name               = 'Sunstone Helm'
		$this.MapObjName         = 'sunstonehelm'
		$this.PurchasePrice      = 1200
		$this.SellPrice          = 600
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 12
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm with sunstone, radiating warmth and light, countering darkness.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
