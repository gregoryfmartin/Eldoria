using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESKYSOVEREIGNPAULDRON
#
###############################################################################

Class BESkySovereignPauldron : BEPauldron {
	BESkySovereignPauldron() : base() {
		$this.Name               = 'Sky Sovereign Pauldron'
		$this.MapObjName         = 'skysovereignpauldron'
		$this.PurchasePrice      = 8850
		$this.SellPrice          = 4425
		$this.TargetStats        = @{
			[StatId]::Defense = 177
			[StatId]::MagicDefense = 80
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Allows effortless flight and control over aerial forces.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
