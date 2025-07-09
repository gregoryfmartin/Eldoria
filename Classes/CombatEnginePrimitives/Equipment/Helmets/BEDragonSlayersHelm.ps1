using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE DRAGON SLAYER'S HELM
#
###############################################################################

Class BEDragonSlayersHelm : BEHelmet {
	BEDragonSlayersHelm() : base() {
		$this.Name               = 'Dragon Slayer''s Helm'
		$this.MapObjName         = 'dragonslayershelm'
		$this.PurchasePrice      = 2000
		$this.SellPrice          = 1000
		$this.TargetStats        = @{
			[StatId]::Defense = 20
			[StatId]::MagicDefense = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm specifically designed for slaying dragons, enhancing anti-dragon abilities.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
