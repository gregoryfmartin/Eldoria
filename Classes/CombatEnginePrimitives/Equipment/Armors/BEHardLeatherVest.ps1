using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEHARDLEATHERVEST
#
###############################################################################

Class BEHardLeatherVest : BEArmor {
	BEHardLeatherVest() : base() {
		$this.Name               = 'Hard Leather Vest'
		$this.MapObjName         = 'hardleathervest'
		$this.PurchasePrice      = 150
		$this.SellPrice          = 75
		$this.TargetStats        = @{
			[StatId]::Defense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A stiff leather vest, slightly more protective.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
