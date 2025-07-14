using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEARCHMAGEPAULDRON
#
###############################################################################

Class BEArchmagePauldron : BEPauldron {
	BEArchmagePauldron() : base() {
		$this.Name               = 'Archmage Pauldron'
		$this.MapObjName         = 'archmagepauldron'
		$this.PurchasePrice      = 1250
		$this.SellPrice          = 625
		$this.TargetStats        = @{
			[StatId]::Defense = 25
			[StatId]::MagicDefense = 6
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A pauldron of immense magical power, worn by master mages.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
