using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEABYSSALPLATE
#
###############################################################################

Class BEAbyssalPlate : BEArmor {
	BEAbyssalPlate() : base() {
		$this.Name               = 'Abyssal Plate'
		$this.MapObjName         = 'abyssalplate'
		$this.PurchasePrice      = 2500
		$this.SellPrice          = 1250
		$this.TargetStats        = @{
			[StatId]::Defense = 34
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Plate armor from the deepest parts of the ocean, incredibly tough.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
