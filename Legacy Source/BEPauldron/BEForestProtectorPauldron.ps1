using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEFORESTPROTECTORPAULDRON
#
###############################################################################

Class BEForestProtectorPauldron : BEPauldron {
	BEForestProtectorPauldron() : base() {
		$this.Name               = 'Forest Protector Pauldron'
		$this.MapObjName         = 'forestprotectorpauldron'
		$this.PurchasePrice      = 8650
		$this.SellPrice          = 4325
		$this.TargetStats        = @{
			[StatId]::Defense = 173
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Offers defense while allowing swift movement through woodlands.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
