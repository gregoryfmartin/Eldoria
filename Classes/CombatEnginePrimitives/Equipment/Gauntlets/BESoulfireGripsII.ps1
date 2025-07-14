using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESOULFIREGRIPSII
#
###############################################################################

Class BESoulfireGripsII : BEGauntlets {
	BESoulfireGripsII() : base() {
		$this.Name               = 'Soulfire Grips II'
		$this.MapObjName         = 'soulfiregripsii'
		$this.PurchasePrice      = 1600
		$this.SellPrice          = 800
		$this.TargetStats        = @{
			[StatId]::Defense = 35
			[StatId]::MagicDefense = 55
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'More potent Soulfire Grips, searing spirits with greater intensity.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
