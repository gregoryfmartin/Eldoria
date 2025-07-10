using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEMOURNERSVEIL
#
###############################################################################

Class BEMournersVeil : BEHelmet {
	BEMournersVeil() : base() {
		$this.Name               = 'Mourner''s Veil'
		$this.MapObjName         = 'mournersveil'
		$this.PurchasePrice      = 70
		$this.SellPrice          = 35
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A dark veil worn by mourners, symbolizing grief.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Female
	}
}
