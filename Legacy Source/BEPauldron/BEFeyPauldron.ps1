using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEFEYPAULDRON
#
###############################################################################

Class BEFeyPauldron : BEPauldron {
	BEFeyPauldron() : base() {
		$this.Name               = 'Fey Pauldron'
		$this.MapObjName         = 'feypauldron'
		$this.PurchasePrice      = 5700
		$this.SellPrice          = 2850
		$this.TargetStats        = @{
			[StatId]::Defense = 114
			[StatId]::MagicDefense = 43
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Woven from moonlight and forest magic, offering subtle protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
