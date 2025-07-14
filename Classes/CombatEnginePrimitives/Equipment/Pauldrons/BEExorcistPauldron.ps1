using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEEXORCISTPAULDRON
#
###############################################################################

Class BEExorcistPauldron : BEPauldron {
	BEExorcistPauldron() : base() {
		$this.Name               = 'Exorcist Pauldron'
		$this.MapObjName         = 'exorcistpauldron'
		$this.PurchasePrice      = 7300
		$this.SellPrice          = 3650
		$this.TargetStats        = @{
			[StatId]::Defense = 146
			[StatId]::MagicDefense = 67
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Designed to ward off demonic entities and evil spirits.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
