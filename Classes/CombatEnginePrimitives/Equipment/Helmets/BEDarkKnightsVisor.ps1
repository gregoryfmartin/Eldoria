using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE DARK KNIGHTS VISOR
#
###############################################################################

Class BEDarkKnightsVisor : BEHelmet {
	BEDarkKnightsVisor() : base() {
		$this.Name               = 'Dark Knight''s Visor'
		$this.MapObjName         = 'darkknightsvisor'
		$this.PurchasePrice      = 1750
		$this.SellPrice          = 875
		$this.TargetStats        = @{
			[StatId]::Defense = 16
			[StatId]::MagicDefense = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A menacing visor worn by dark knights, instilling fear in enemies.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
