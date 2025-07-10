using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEMOONSTONEBRACERSII
#
###############################################################################

Class BEMoonstoneBracersII : BEGauntlets {
	BEMoonstoneBracersII() : base() {
		$this.Name               = 'Moonstone Bracers II'
		$this.MapObjName         = 'moonstonebracersii'
		$this.PurchasePrice      = 1080
		$this.SellPrice          = 540
		$this.TargetStats        = @{
			[StatId]::Defense = 22
			[StatId]::MagicDefense = 42
			[StatId]::Accuracy = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Brighter Moonstone Bracers, enhancing nocturnal endeavors further.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Female
	}
}
