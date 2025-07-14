using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDRYADSEMBRACE
#
###############################################################################

Class BEDryadsEmbrace : BEGauntlets {
	BEDryadsEmbrace() : base() {
		$this.Name               = 'Dryad''s Embrace'
		$this.MapObjName         = 'dryadsembrace'
		$this.PurchasePrice      = 450
		$this.SellPrice          = 225
		$this.TargetStats        = @{
			[StatId]::Defense = 8
			[StatId]::MagicDefense = 26
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gloves woven with living vines, connected to nature''s magic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
