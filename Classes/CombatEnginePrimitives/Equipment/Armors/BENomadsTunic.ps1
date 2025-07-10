using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BENOMADSTUNIC
#
###############################################################################

Class BENomadsTunic : BEArmor {
	BENomadsTunic() : base() {
		$this.Name               = 'Nomad''s Tunic'
		$this.MapObjName         = 'nomadstunic'
		$this.PurchasePrice      = 90
		$this.SellPrice          = 45
		$this.TargetStats        = @{
			[StatId]::Defense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A simple, durable tunic for desert wanderers.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
