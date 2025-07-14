using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECOMMANDERSPAULDRON
#
###############################################################################

Class BECommandersPauldron : BEPauldron {
	BECommandersPauldron() : base() {
		$this.Name               = 'Commander''s Pauldron'
		$this.MapObjName         = 'commanderspauldron'
		$this.PurchasePrice      = 900
		$this.SellPrice          = 450
		$this.TargetStats        = @{
			[StatId]::Defense = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Grants authority and inspires allies on the battlefield.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}
