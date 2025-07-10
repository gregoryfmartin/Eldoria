using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEEMERALDROBE
#
###############################################################################

Class BEEmeraldRobe : BEArmor {
	BEEmeraldRobe() : base() {
		$this.Name               = 'Emerald Robe'
		$this.MapObjName         = 'emeraldrobe'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 26
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A vibrant green robe adorned with emeralds, enhancing nature magic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
