using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEPHOENIXFEATHERGLOVES
#
###############################################################################

Class BEPhoenixFeatherGloves : BEGauntlets {
	BEPhoenixFeatherGloves() : base() {
		$this.Name               = 'Phoenix Feather Gloves'
		$this.MapObjName         = 'phoenixfeathergloves'
		$this.PurchasePrice      = 1250
		$this.SellPrice          = 625
		$this.TargetStats        = @{
			[StatId]::Defense = 28
			[StatId]::MagicDefense = 48
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gloves woven with phoenix feathers, offering light and healing.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
