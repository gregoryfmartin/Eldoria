using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESHAMANSROBE
#
###############################################################################

Class BEShamansRobe : BEArmor {
	BEShamansRobe() : base() {
		$this.Name               = 'Shaman''s Robe'
		$this.MapObjName         = 'shamansrobe'
		$this.PurchasePrice      = 750
		$this.SellPrice          = 375
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 23
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A ceremonial robe adorned with totems and charms.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
