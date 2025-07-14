using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BETIMELESSPAULDRON
#
###############################################################################

Class BETimelessPauldron : BEPauldron {
	BETimelessPauldron() : base() {
		$this.Name               = 'Timeless Pauldron'
		$this.MapObjName         = 'timelesspauldron'
		$this.PurchasePrice      = 6600
		$this.SellPrice          = 3300
		$this.TargetStats        = @{
			[StatId]::Defense = 132
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Unaffected by the flow of time, granting immense durability.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
