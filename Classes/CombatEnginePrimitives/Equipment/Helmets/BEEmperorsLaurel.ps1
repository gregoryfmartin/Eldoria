using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEEMPERORSLAUREL
#
###############################################################################

Class BEEmperorsLaurel : BEHelmet {
	BEEmperorsLaurel() : base() {
		$this.Name               = 'Emperor''s Laurel'
		$this.MapObjName         = 'emperorslaurel'
		$this.PurchasePrice      = 2900
		$this.SellPrice          = 1450
		$this.TargetStats        = @{
			[StatId]::Defense = 15
			[StatId]::MagicDefense = 15
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A golden laurel wreath worn by emperors, symbolizing absolute power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
