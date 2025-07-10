using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BENOMADPAULDRON
#
###############################################################################

Class BENomadPauldron : BEPauldron {
	BENomadPauldron() : base() {
		$this.Name               = 'Nomad Pauldron'
		$this.MapObjName         = 'nomadpauldron'
		$this.PurchasePrice      = 2100
		$this.SellPrice          = 1050
		$this.TargetStats        = @{
			[StatId]::Defense = 42
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Practical and durable for endless journeys.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}
