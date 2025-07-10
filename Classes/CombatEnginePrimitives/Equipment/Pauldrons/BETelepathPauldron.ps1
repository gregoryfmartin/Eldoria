using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BETELEPATHPAULDRON
#
###############################################################################

Class BETelepathPauldron : BEPauldron {
	BETelepathPauldron() : base() {
		$this.Name               = 'Telepath Pauldron'
		$this.MapObjName         = 'telepathpauldron'
		$this.PurchasePrice      = 7700
		$this.SellPrice          = 3850
		$this.TargetStats        = @{
			[StatId]::Defense = 154
			[StatId]::MagicDefense = 75
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Grants the power of telepathy, for mental communication.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
