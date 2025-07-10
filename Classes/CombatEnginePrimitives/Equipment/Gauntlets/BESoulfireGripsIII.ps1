using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESOULFIREGRIPSIII
#
###############################################################################

Class BESoulfireGripsIII : BEGauntlets {
	BESoulfireGripsIII() : base() {
		$this.Name               = 'Soulfire Grips III'
		$this.MapObjName         = 'soulfiregripsiii'
		$this.PurchasePrice      = 1700
		$this.SellPrice          = 850
		$this.TargetStats        = @{
			[StatId]::Defense = 40
			[StatId]::MagicDefense = 60
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Final tier Soulfire Grips, searing spirits with maximum intensity.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
