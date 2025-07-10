using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECURSEDROBE
#
###############################################################################

Class BECursedRobe : BEArmor {
	BECursedRobe() : base() {
		$this.Name               = 'Cursed Robe'
		$this.MapObjName         = 'cursedrobe'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 30
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A powerful but dangerous robe, drains health but boosts magic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
