using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEVAMPIRICROBE
#
###############################################################################

Class BEVampiricRobe : BEArmor {
	BEVampiricRobe() : base() {
		$this.Name               = 'Vampiric Robe'
		$this.MapObjName         = 'vampiricrobe'
		$this.PurchasePrice      = 1550
		$this.SellPrice          = 775
		$this.TargetStats        = @{
			[StatId]::Defense = 3
			[StatId]::MagicDefense = 32
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robe that subtly drains life from enemies during combat.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
