using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECRIMSONGAUNTLETS
#
###############################################################################

Class BECrimsonGauntlets : BEGauntlets {
	BECrimsonGauntlets() : base() {
		$this.Name               = 'Crimson Gauntlets'
		$this.MapObjName         = 'crimsongauntlets'
		$this.PurchasePrice      = 530
		$this.SellPrice          = 265
		$this.TargetStats        = @{
			[StatId]::Defense = 26
			[StatId]::MagicDefense = 7
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Blood-stained gauntlets of a ruthless warrior.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
