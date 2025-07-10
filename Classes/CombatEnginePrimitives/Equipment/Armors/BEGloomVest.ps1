using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGLOOMVEST
#
###############################################################################

Class BEGloomVest : BEArmor {
	BEGloomVest() : base() {
		$this.Name               = 'Gloom Vest'
		$this.MapObjName         = 'gloomvest'
		$this.PurchasePrice      = 240
		$this.SellPrice          = 120
		$this.TargetStats        = @{
			[StatId]::Defense = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A dark vest that helps the wearer blend into shadows.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
