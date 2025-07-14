using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECHAMPIONSBREASTPLATE
#
###############################################################################

Class BEChampionsBreastplate : BEArmor {
	BEChampionsBreastplate() : base() {
		$this.Name               = 'Champion''s Breastplate'
		$this.MapObjName         = 'championsbreastplate'
		$this.PurchasePrice      = 1900
		$this.SellPrice          = 950
		$this.TargetStats        = @{
			[StatId]::Defense = 30
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'The shining breastplate of a revered champion.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
