using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDREAMWEAVERPAULDRON
#
###############################################################################

Class BEDreamWeaverPauldron : BEPauldron {
	BEDreamWeaverPauldron() : base() {
		$this.Name               = 'Dream Weaver Pauldron'
		$this.MapObjName         = 'dreamweaverpauldron'
		$this.PurchasePrice      = 4800
		$this.SellPrice          = 2400
		$this.TargetStats        = @{
			[StatId]::Defense = 96
			[StatId]::MagicDefense = 36
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Grants access to dreams, allowing for illusory defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
