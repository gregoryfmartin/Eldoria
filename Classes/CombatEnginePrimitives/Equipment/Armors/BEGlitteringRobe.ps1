using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGLITTERINGROBE
#
###############################################################################

Class BEGlitteringRobe : BEArmor {
	BEGlitteringRobe() : base() {
		$this.Name               = 'Glittering Robe'
		$this.MapObjName         = 'glitteringrobe'
		$this.PurchasePrice      = 600
		$this.SellPrice          = 300
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robe woven with fine silver threads, sparkles in the light.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
