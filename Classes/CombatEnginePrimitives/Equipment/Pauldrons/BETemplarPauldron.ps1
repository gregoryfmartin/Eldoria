using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BETEMPLARPAULDRON
#
###############################################################################

Class BETemplarPauldron : BEPauldron {
	BETemplarPauldron() : base() {
		$this.Name               = 'Templar Pauldron'
		$this.MapObjName         = 'templarpauldron'
		$this.PurchasePrice      = 7350
		$this.SellPrice          = 3675
		$this.TargetStats        = @{
			[StatId]::Defense = 147
			[StatId]::MagicDefense = 68
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A symbol of unwavering faith and military might.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
