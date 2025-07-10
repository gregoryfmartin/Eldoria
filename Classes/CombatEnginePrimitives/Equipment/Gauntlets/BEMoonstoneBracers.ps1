using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEMOONSTONEBRACERS
#
###############################################################################

Class BEMoonstoneBracers : BEGauntlets {
	BEMoonstoneBracers() : base() {
		$this.Name               = 'Moonstone Bracers'
		$this.MapObjName         = 'moonstonebracers'
		$this.PurchasePrice      = 980
		$this.SellPrice          = 490
		$this.TargetStats        = @{
			[StatId]::Defense = 20
			[StatId]::MagicDefense = 38
			[StatId]::Accuracy = 8
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Bracers glowing with soft moonstone, aiding nocturnal endeavors.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Female
	}
}
