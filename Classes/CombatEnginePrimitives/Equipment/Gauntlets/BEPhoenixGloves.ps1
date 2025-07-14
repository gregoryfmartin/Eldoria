using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEPHOENIXGLOVES
#
###############################################################################

Class BEPhoenixGloves : BEGauntlets {
	BEPhoenixGloves() : base() {
		$this.Name               = 'Phoenix Gloves'
		$this.MapObjName         = 'phoenixgloves'
		$this.PurchasePrice      = 720
		$this.SellPrice          = 360
		$this.TargetStats        = @{
			[StatId]::Defense = 16
			[StatId]::MagicDefense = 30
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gloves said to be touched by a phoenix, offering fiery defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
