using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEABYSSALPLATEGAUNTLETSIII
#
###############################################################################

Class BEAbyssalPlateGauntletsIII : BEGauntlets {
	BEAbyssalPlateGauntletsIII() : base() {
		$this.Name               = 'Abyssal Plate Gauntlets III'
		$this.MapObjName         = 'abyssalplategauntletsiii'
		$this.PurchasePrice      = 2300
		$this.SellPrice          = 1150
		$this.TargetStats        = @{
			[StatId]::Defense = 110
			[StatId]::MagicDefense = 40
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Final tier Abyssal Plate Gauntlets, unyielding resilience.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
