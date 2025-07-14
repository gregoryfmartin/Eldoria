using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEWYVERNCLAWS
#
###############################################################################

Class BEWyvernClaws : BEGauntlets {
	BEWyvernClaws() : base() {
		$this.Name               = 'Wyvern Claws'
		$this.MapObjName         = 'wyvernclaws'
		$this.PurchasePrice      = 580
		$this.SellPrice          = 290
		$this.TargetStats        = @{
			[StatId]::Defense = 26
			[StatId]::MagicDefense = 9
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets adorned with wyvern talons, sharp and intimidating.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
