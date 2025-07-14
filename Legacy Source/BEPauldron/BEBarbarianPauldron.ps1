using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEBARBARIANPAULDRON
#
###############################################################################

Class BEBarbarianPauldron : BEPauldron {
	BEBarbarianPauldron() : base() {
		$this.Name               = 'Barbarian Pauldron'
		$this.MapObjName         = 'barbarianpauldron'
		$this.PurchasePrice      = 8450
		$this.SellPrice          = 4225
		$this.TargetStats        = @{
			[StatId]::Defense = 169
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Minimal but effective, allowing for swift, powerful strikes.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
