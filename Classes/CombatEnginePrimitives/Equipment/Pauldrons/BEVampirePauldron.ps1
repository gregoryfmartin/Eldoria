using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEVAMPIREPAULDRON
#
###############################################################################

Class BEVampirePauldron : BEPauldron {
	BEVampirePauldron() : base() {
		$this.Name               = 'Vampire Pauldron'
		$this.MapObjName         = 'vampirepauldron'
		$this.PurchasePrice      = 5050
		$this.SellPrice          = 2525
		$this.TargetStats        = @{
			[StatId]::Defense = 101
			[StatId]::MagicDefense = 39
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Feeds on the life force of enemies, restoring health to the wearer.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
