using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEZEALOTSHOLYFISTS
#
###############################################################################

Class BEZealotsHolyFists : BEGauntlets {
	BEZealotsHolyFists() : base() {
		$this.Name               = 'Zealot''s Holy Fists'
		$this.MapObjName         = 'zealotsholyfists'
		$this.PurchasePrice      = 620
		$this.SellPrice          = 310
		$this.TargetStats        = @{
			[StatId]::Defense = 32
			[StatId]::MagicDefense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Fists of a truly righteous zealot, imbued with divine fervor.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
