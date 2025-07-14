using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEFROSTWORNGRIPS
#
###############################################################################

Class BEFrostwornGrips : BEGauntlets {
	BEFrostwornGrips() : base() {
		$this.Name               = 'Frostworn Grips'
		$this.MapObjName         = 'frostworngrips'
		$this.PurchasePrice      = 370
		$this.SellPrice          = 185
		$this.TargetStats        = @{
			[StatId]::Defense = 19
			[StatId]::MagicDefense = 9
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Grips that retain a chilling touch from icy encounters.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
