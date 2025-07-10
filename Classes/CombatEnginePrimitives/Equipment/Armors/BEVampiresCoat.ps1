using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEVAMPIRESCOAT
#
###############################################################################

Class BEVampiresCoat : BEArmor {
	BEVampiresCoat() : base() {
		$this.Name               = 'Vampire''s Coat'
		$this.MapObjName         = 'vampirescoat'
		$this.PurchasePrice      = 1300
		$this.SellPrice          = 650
		$this.TargetStats        = @{
			[StatId]::Defense = 10
			[StatId]::MagicDefense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'An elegant dark coat, said to sustain the wearer''s life.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
