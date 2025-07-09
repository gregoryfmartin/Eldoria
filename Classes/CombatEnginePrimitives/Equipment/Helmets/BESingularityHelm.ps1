using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE SINGULARITY HELM
#
###############################################################################

Class BESingularityHelm : BEHelmet {
	BESingularityHelm() : base() {
		$this.Name               = 'Singularity Helm'
		$this.MapObjName         = 'singularityhelm'
		$this.PurchasePrice      = 8500
		$this.SellPrice          = 4250
		$this.TargetStats        = @{
			[StatId]::Defense = 55
			[StatId]::MagicDefense = 55
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm that creates a miniature singularity, pulling enemies in.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
