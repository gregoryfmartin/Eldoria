using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEBARDSHARMONYGEM
#
###############################################################################

Class BEBardsHarmonyGem : BEJewelry {
	BEBardsHarmonyGem() : base() {
		$this.Name               = 'Bard''s Harmony Gem'
		$this.MapObjName         = 'bardsharmonygem'
		$this.PurchasePrice      = 1200
		$this.SellPrice          = 600
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 2
			[StatId]::MagicDefense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A gem that resonates with perfect harmony.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
