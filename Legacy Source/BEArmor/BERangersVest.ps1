using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BERANGERSVEST
#
###############################################################################

Class BERangersVest : BEArmor {
	BERangersVest() : base() {
		$this.Name               = 'Ranger''s Vest'
		$this.MapObjName         = 'rangersvest'
		$this.PurchasePrice      = 170
		$this.SellPrice          = 85
		$this.TargetStats        = @{
			[StatId]::Defense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A practical vest with many pockets, good for outdoor life.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
