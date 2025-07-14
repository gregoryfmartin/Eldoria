using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BELEATHERVEST
#
###############################################################################

Class BELeatherVest : BEArmor {
	BELeatherVest() : base() {
		$this.Name               = 'Leather Vest'
		$this.MapObjName         = 'leathervest'
		$this.PurchasePrice      = 80
		$this.SellPrice          = 40
		$this.TargetStats        = @{
			[StatId]::Defense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A basic leather vest offering minimal protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
