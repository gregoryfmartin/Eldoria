using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEWARRIORCAPE
#
###############################################################################

Class BEWarriorCape : BECape {
	BEWarriorCape() : base() {
		$this.Name               = 'Warrior Cape'
		$this.MapObjName         = 'warriorcape'
		$this.PurchasePrice      = 450
		$this.SellPrice          = 225
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robust cape, offering minor protection in combat.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Male
	}
}
