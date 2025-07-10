using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEINQUISITORSROBE
#
###############################################################################

Class BEInquisitorsRobe : BEArmor {
	BEInquisitorsRobe() : base() {
		$this.Name               = 'Inquisitor''s Robe'
		$this.MapObjName         = 'inquisitorsrobe'
		$this.PurchasePrice      = 900
		$this.SellPrice          = 450
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 25
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A grim robe worn by those who seek out evil.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
