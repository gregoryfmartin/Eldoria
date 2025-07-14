using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEPOACHERSVEST
#
###############################################################################

Class BEPoachersVest : BEArmor {
	BEPoachersVest() : base() {
		$this.Name               = 'Poacher''s Vest'
		$this.MapObjName         = 'poachersvest'
		$this.PurchasePrice      = 180
		$this.SellPrice          = 90
		$this.TargetStats        = @{
			[StatId]::Defense = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A stealthy vest with many hidden compartments.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
