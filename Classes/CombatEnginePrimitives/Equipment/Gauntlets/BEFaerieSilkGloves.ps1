using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEFAERIESILKGLOVES
#
###############################################################################

Class BEFaerieSilkGloves : BEGauntlets {
	BEFaerieSilkGloves() : base() {
		$this.Name               = 'Faerie Silk Gloves'
		$this.MapObjName         = 'faeriesilkgloves'
		$this.PurchasePrice      = 560
		$this.SellPrice          = 280
		$this.TargetStats        = @{
			[StatId]::Defense = 12
			[StatId]::MagicDefense = 35
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gloves woven from mystical faerie silk, incredibly soft yet protective.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
