using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGOBLINPAULDRON
#
###############################################################################

Class BEGoblinPauldron : BEPauldron {
	BEGoblinPauldron() : base() {
		$this.Name               = 'Goblin Pauldron'
		$this.MapObjName         = 'goblinpauldron'
		$this.PurchasePrice      = 5900
		$this.SellPrice          = 2950
		$this.TargetStats        = @{
			[StatId]::Defense = 118
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Crudely assembled but surprisingly effective in a pinch.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
