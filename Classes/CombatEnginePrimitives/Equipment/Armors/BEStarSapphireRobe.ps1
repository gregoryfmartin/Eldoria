using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESTARSAPPHIREROBE
#
###############################################################################

Class BEStarSapphireRobe : BEArmor {
	BEStarSapphireRobe() : base() {
		$this.Name               = 'Star Sapphire Robe'
		$this.MapObjName         = 'starsapphirerobe'
		$this.PurchasePrice      = 1500
		$this.SellPrice          = 750
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 33
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A deep blue robe embedded with star sapphires, very potent.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
