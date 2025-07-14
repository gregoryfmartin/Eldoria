using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESPARKPAULDRON
#
###############################################################################

Class BESparkPauldron : BEPauldron {
	BESparkPauldron() : base() {
		$this.Name               = 'Spark Pauldron'
		$this.MapObjName         = 'sparkpauldron'
		$this.PurchasePrice      = 4250
		$this.SellPrice          = 2125
		$this.TargetStats        = @{
			[StatId]::Defense = 85
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Emits small sparks, offering minor electrical resistance.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
