using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BERUNESMITHSROBE
#
###############################################################################

Class BERunesmithsRobe : BEArmor {
	BERunesmithsRobe() : base() {
		$this.Name               = 'Runesmith''s Robe'
		$this.MapObjName         = 'runesmithsrobe'
		$this.PurchasePrice      = 1600
		$this.SellPrice          = 800
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 34
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A heavy robe adorned with glowing runes, enhances enchanting.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
