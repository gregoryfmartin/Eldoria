using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESERPENTHIDEROBE
#
###############################################################################

Class BESerpenthideRobe : BEArmor {
	BESerpenthideRobe() : base() {
		$this.Name               = 'Serpenthide Robe'
		$this.MapObjName         = 'serpenthiderobe'
		$this.PurchasePrice      = 1400
		$this.SellPrice          = 700
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 30
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robe made from the scales of a giant serpent, offers resistance to poison.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
