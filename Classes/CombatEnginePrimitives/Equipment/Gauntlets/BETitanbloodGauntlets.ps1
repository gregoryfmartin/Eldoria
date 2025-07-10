using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BETITANBLOODGAUNTLETS
#
###############################################################################

Class BETitanbloodGauntlets : BEGauntlets {
	BETitanbloodGauntlets() : base() {
		$this.Name               = 'Titanblood Gauntlets'
		$this.MapObjName         = 'titanbloodgauntlets'
		$this.PurchasePrice      = 1300
		$this.SellPrice          = 650
		$this.TargetStats        = @{
			[StatId]::Defense = 65
			[StatId]::MagicDefense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets stained with titan blood, granting immense strength.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
