using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEBERSERKERPAULDRON
#
###############################################################################

Class BEBerserkerPauldron : BEPauldron {
	BEBerserkerPauldron() : base() {
		$this.Name               = 'Berserker Pauldron'
		$this.MapObjName         = 'berserkerpauldron'
		$this.PurchasePrice      = 8300
		$this.SellPrice          = 4150
		$this.TargetStats        = @{
			[StatId]::Defense = 166
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Infuses its wearer with uncontrolled rage, boosting defense at a cost.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}
