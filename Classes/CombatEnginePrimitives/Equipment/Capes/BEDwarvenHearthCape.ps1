using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDWARVENHEARTHCAPE
#
###############################################################################

Class BEDwarvenHearthCape : BECape {
	BEDwarvenHearthCape() : base() {
		$this.Name               = 'Dwarven Hearth Cape'
		$this.MapObjName         = 'dwarvenhearthcape'
		$this.PurchasePrice      = 650
		$this.SellPrice          = 325
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A thick, warm cape from dwarven forges.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Male
	}
}
