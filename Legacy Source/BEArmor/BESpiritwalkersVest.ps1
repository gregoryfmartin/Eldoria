using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESPIRITWALKERSVEST
#
###############################################################################

Class BESpiritwalkersVest : BEArmor {
	BESpiritwalkersVest() : base() {
		$this.Name               = 'Spiritwalker''s Vest'
		$this.MapObjName         = 'spiritwalkersvest'
		$this.PurchasePrice      = 650
		$this.SellPrice          = 325
		$this.TargetStats        = @{
			[StatId]::Defense = 9
			[StatId]::MagicDefense = 9
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A vest that aids in traversing spiritual realms, light but protective.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
