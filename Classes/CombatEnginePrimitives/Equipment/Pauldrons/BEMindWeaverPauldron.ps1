using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEMINDWEAVERPAULDRON
#
###############################################################################

Class BEMindWeaverPauldron : BEPauldron {
	BEMindWeaverPauldron() : base() {
		$this.Name               = 'Mind Weaver Pauldron'
		$this.MapObjName         = 'mindweaverpauldron'
		$this.PurchasePrice      = 7650
		$this.SellPrice          = 3825
		$this.TargetStats        = @{
			[StatId]::Defense = 153
			[StatId]::MagicDefense = 74
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Allows for subtle manipulation of thoughts and emotions.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
