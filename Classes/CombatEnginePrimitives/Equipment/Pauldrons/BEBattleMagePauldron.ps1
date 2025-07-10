using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEBATTLEMAGEPAULDRON
#
###############################################################################

Class BEBattleMagePauldron : BEPauldron {
	BEBattleMagePauldron() : base() {
		$this.Name               = 'Battle Mage Pauldron'
		$this.MapObjName         = 'battlemagepauldron'
		$this.PurchasePrice      = 7050
		$this.SellPrice          = 3525
		$this.TargetStats        = @{
			[StatId]::Defense = 141
			[StatId]::MagicDefense = 62
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Allows full mobility for spellcasting while offering protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
