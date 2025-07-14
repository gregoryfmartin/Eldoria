using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEPHOENIXFEATHERGLOVESII
#
###############################################################################

Class BEPhoenixFeatherGlovesII : BEGauntlets {
	BEPhoenixFeatherGlovesII() : base() {
		$this.Name               = 'Phoenix Feather Gloves II'
		$this.MapObjName         = 'phoenixfeatherglovesii'
		$this.PurchasePrice      = 1350
		$this.SellPrice          = 675
		$this.TargetStats        = @{
			[StatId]::Defense = 32
			[StatId]::MagicDefense = 52
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'More protective Phoenix Feather Gloves, enhanced healing.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
