using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BENECROTICGREAVES
#
###############################################################################

Class BENecroticGreaves : BEGreaves {
	BENecroticGreaves() : base() {
		$this.Name               = 'Necrotic Greaves'
		$this.MapObjName         = 'necroticgreaves'
		$this.PurchasePrice      = 1200
		$this.SellPrice          = 600
		$this.TargetStats        = @{
			[StatId]::Defense = 48
			[StatId]::MagicDefense = 30
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves linked to death magic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
