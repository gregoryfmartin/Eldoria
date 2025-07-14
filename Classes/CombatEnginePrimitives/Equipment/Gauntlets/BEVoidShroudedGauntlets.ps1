using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEVOIDSHROUDEDGAUNTLETS
#
###############################################################################

Class BEVoidShroudedGauntlets : BEGauntlets {
	BEVoidShroudedGauntlets() : base() {
		$this.Name               = 'Void Shrouded Gauntlets'
		$this.MapObjName         = 'voidshroudedgauntlets'
		$this.PurchasePrice      = 1400
		$this.SellPrice          = 700
		$this.TargetStats        = @{
			[StatId]::Defense = 70
			[StatId]::MagicDefense = 30
			[StatId]::Accuracy = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gauntlets entirely cloaked in void energy, hard to perceive.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Unisex
	}
}
