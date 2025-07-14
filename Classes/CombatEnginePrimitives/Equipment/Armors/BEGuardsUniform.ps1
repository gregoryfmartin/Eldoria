using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGUARDSUNIFORM
#
###############################################################################

Class BEGuardsUniform : BEArmor {
	BEGuardsUniform() : base() {
		$this.Name               = 'Guard''s Uniform'
		$this.MapObjName         = 'guardsuniform'
		$this.PurchasePrice      = 150
		$this.SellPrice          = 75
		$this.TargetStats        = @{
			[StatId]::Defense = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'The standard uniform of a town guard, offers moderate protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
