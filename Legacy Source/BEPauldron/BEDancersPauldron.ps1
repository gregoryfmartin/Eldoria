using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDANCERSPAULDRON
#
###############################################################################

Class BEDancersPauldron : BEPauldron {
	BEDancersPauldron() : base() {
		$this.Name               = 'Dancer''s Pauldron'
		$this.MapObjName         = 'dancerspauldron'
		$this.PurchasePrice      = 7950
		$this.SellPrice          = 3975
		$this.TargetStats        = @{
			[StatId]::Defense = 159
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Light and flexible, allowing for graceful movement and evasion.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Female
	}
}
