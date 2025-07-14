using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEMOONLITDEWGLOVES
#
###############################################################################

Class BEMoonlitDewGloves : BEGauntlets {
	BEMoonlitDewGloves() : base() {
		$this.Name               = 'Moonlit Dew Gloves'
		$this.MapObjName         = 'moonlitdewgloves'
		$this.PurchasePrice      = 650
		$this.SellPrice          = 325
		$this.TargetStats        = @{
			[StatId]::Defense = 12
			[StatId]::MagicDefense = 30
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gloves shimmering with moonlight dew, granting restorative power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
