using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEBARDSVEST
#
###############################################################################

Class BEBardsVest : BEArmor {
	BEBardsVest() : base() {
		$this.Name               = 'Bard''s Vest'
		$this.MapObjName         = 'bardsvest'
		$this.PurchasePrice      = 100
		$this.SellPrice          = 50
		$this.TargetStats        = @{
			[StatId]::Defense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A flashy vest that helps with performances, slight charm boost.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
