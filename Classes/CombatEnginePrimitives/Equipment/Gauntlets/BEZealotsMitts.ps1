using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEZEALOTSMITTS
#
###############################################################################

Class BEZealotsMitts : BEGauntlets {
	BEZealotsMitts() : base() {
		$this.Name               = 'Zealot''s Mitts'
		$this.MapObjName         = 'zealotsmitts'
		$this.PurchasePrice      = 110
		$this.SellPrice          = 55
		$this.TargetStats        = @{
			[StatId]::Defense = 4
			[StatId]::MagicDefense = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Light mitts for a quick, devoted follower.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
