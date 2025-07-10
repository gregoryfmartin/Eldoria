using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESPECTERVEST
#
###############################################################################

Class BESpecterVest : BEArmor {
	BESpecterVest() : base() {
		$this.Name               = 'Specter Vest'
		$this.MapObjName         = 'spectervest'
		$this.PurchasePrice      = 200
		$this.SellPrice          = 100
		$this.TargetStats        = @{
			[StatId]::Defense = 3
			[StatId]::MagicDefense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A vest that offers slight resistance to spiritual attacks.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
