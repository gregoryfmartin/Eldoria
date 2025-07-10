using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEFORESTWHISPERCHARM
#
###############################################################################

Class BEForestwhisperCharm : BEJewelry {
	BEForestwhisperCharm() : base() {
		$this.Name               = 'Forestwhisper Charm'
		$this.MapObjName         = 'forestwhispercharm'
		$this.PurchasePrice      = 950
		$this.SellPrice          = 475
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 1
			[StatId]::MagicDefense = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A charm that seems to hum with the sounds of the forest.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
