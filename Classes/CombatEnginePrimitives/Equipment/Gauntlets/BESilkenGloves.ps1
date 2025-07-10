using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESILKENGLOVES
#
###############################################################################

Class BESilkenGloves : BEGauntlets {
	BESilkenGloves() : base() {
		$this.Name               = 'Silken Gloves'
		$this.MapObjName         = 'silkengloves'
		$this.PurchasePrice      = 90
		$this.SellPrice          = 45
		$this.TargetStats        = @{
			[StatId]::Defense = 1
			[StatId]::MagicDefense = 8
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Soft, elegant gloves offering minimal protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
