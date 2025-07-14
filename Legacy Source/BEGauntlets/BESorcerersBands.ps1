using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESORCERERSBANDS
#
###############################################################################

Class BESorcerersBands : BEGauntlets {
	BESorcerersBands() : base() {
		$this.Name               = 'Sorcerer''s Bands'
		$this.MapObjName         = 'sorcerersbands'
		$this.PurchasePrice      = 280
		$this.SellPrice          = 140
		$this.TargetStats        = @{
			[StatId]::Defense = 6
			[StatId]::MagicDefense = 15
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Enchanted wristbands, amplifying magical potency.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
