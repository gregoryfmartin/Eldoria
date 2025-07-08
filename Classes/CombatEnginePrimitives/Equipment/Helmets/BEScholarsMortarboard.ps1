using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE SCHOLARS MORTARBOARD
#
###############################################################################

Class BEScholarsMortarboard : BEHelmet {
	BEScholarsMortarboard() : base() {
		$this.Name               = 'Scholar''s Mortarboard'
		$this.MapObjName         = 'scholarsmortarboard'
		$this.PurchasePrice      = 80
		$this.SellPrice          = 40
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A traditional academic hat, said to improve focus and memory.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
