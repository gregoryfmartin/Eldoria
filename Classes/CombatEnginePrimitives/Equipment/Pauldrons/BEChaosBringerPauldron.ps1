using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECHAOSBRINGERPAULDRON
#
###############################################################################

Class BEChaosBringerPauldron : BEPauldron {
	BEChaosBringerPauldron() : base() {
		$this.Name               = 'Chaos Bringer Pauldron'
		$this.MapObjName         = 'chaosbringerpauldron'
		$this.PurchasePrice      = 10050
		$this.SellPrice          = 5025
		$this.TargetStats        = @{
			[StatId]::Defense = 201
			[StatId]::MagicDefense = 89
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Embodies pure chaos, creating unpredictable and destructive effects.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
