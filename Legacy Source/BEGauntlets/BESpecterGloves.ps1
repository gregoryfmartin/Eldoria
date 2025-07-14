using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESPECTERGLOVES
#
###############################################################################

Class BESpecterGloves : BEGauntlets {
	BESpecterGloves() : base() {
		$this.Name               = 'Specter Gloves'
		$this.MapObjName         = 'spectergloves'
		$this.PurchasePrice      = 850
		$this.SellPrice          = 425
		$this.TargetStats        = @{
			[StatId]::Defense = 10
			[StatId]::MagicDefense = 33
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Gloves allowing passage through solid objects.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
