using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEENGINEERSVEST
#
###############################################################################

Class BEEngineersVest : BEArmor {
	BEEngineersVest() : base() {
		$this.Name               = 'Engineer''s Vest'
		$this.MapObjName         = 'engineersvest'
		$this.PurchasePrice      = 140
		$this.SellPrice          = 70
		$this.TargetStats        = @{
			[StatId]::Defense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A vest with various tools and pockets, offers minor defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
