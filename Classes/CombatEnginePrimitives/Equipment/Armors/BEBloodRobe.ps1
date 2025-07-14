using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEBLOODROBE
#
###############################################################################

Class BEBloodRobe : BEArmor {
	BEBloodRobe() : base() {
		$this.Name               = 'Blood Robe'
		$this.MapObjName         = 'bloodrobe'
		$this.PurchasePrice      = 1400
		$this.SellPrice          = 700
		$this.TargetStats        = @{
			[StatId]::Defense = 5
			[StatId]::MagicDefense = 30
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robe stained with ancient blood, granting power through sacrifice.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
