using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEZEALOTSFISTS
#
###############################################################################

Class BEZealotsFists : BEGauntlets {
	BEZealotsFists() : base() {
		$this.Name               = 'Zealot''s Fists'
		$this.MapObjName         = 'zealotsfists'
		$this.PurchasePrice      = 520
		$this.SellPrice          = 260
		$this.TargetStats        = @{
			[StatId]::Defense = 28
			[StatId]::MagicDefense = 8
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Fists of a righteous warrior, imbued with fervor.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
