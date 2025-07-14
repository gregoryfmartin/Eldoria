using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESORCERERBOOTS
#
###############################################################################

Class BESorcererBoots : BEBoots {
	BESorcererBoots() : base() {
		$this.Name               = 'Sorcerer Boots'
		$this.MapObjName         = 'sorcererboots'
		$this.PurchasePrice      = 420
		$this.SellPrice          = 210
		$this.TargetStats        = @{
			[StatId]::Defense = 9
			[StatId]::MagicDefense = 28
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Light boots that aid in spellcasting.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
