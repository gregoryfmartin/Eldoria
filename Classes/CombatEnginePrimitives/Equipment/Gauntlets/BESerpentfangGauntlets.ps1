using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESERPENTFANGGAUNTLETS
#
###############################################################################

Class BESerpentfangGauntlets : BEGauntlets {
	BESerpentfangGauntlets() : base() {
		$this.Name               = 'Serpentfang Gauntlets'
		$this.MapObjName         = 'serpentfanggauntlets'
		$this.PurchasePrice      = 850
		$this.SellPrice          = 425
		$this.TargetStats        = @{
			[StatId]::Defense = 38
			[StatId]::MagicDefense = 15
			[StatId]::Accuracy = 8
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets with venomous serpent fangs, for deadly strikes.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Unisex
	}
}
