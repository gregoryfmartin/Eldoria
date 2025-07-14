using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESOLARFLAREDIADEM
#
###############################################################################

Class BESolarFlareDiadem : BEHelmet {
	BESolarFlareDiadem() : base() {
		$this.Name               = 'Solar Flare Diadem'
		$this.MapObjName         = 'solarflarediadem'
		$this.PurchasePrice      = 4800
		$this.SellPrice          = 2400
		$this.TargetStats        = @{
			[StatId]::Defense = 15
			[StatId]::MagicDefense = 38
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A diadem that radiates solar energy, providing protection and offensive power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
