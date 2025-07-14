using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESERAPHICMITTS
#
###############################################################################

Class BESeraphicMitts : BEGauntlets {
	BESeraphicMitts() : base() {
		$this.Name               = 'Seraphic Mitts'
		$this.MapObjName         = 'seraphicmitts'
		$this.PurchasePrice      = 700
		$this.SellPrice          = 350
		$this.TargetStats        = @{
			[StatId]::Defense = 15
			[StatId]::MagicDefense = 40
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Feather-light mitts of angelic origin, offering celestial defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
