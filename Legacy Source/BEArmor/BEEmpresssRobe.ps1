using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEEMPRESSSROBE
#
###############################################################################

Class BEEmpresssRobe : BEArmor {
	BEEmpresssRobe() : base() {
		$this.Name               = 'Empress''s Robe'
		$this.MapObjName         = 'empresssrobe'
		$this.PurchasePrice      = 1500
		$this.SellPrice          = 750
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 32
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A regal robe, richly embroidered and imbued with subtle power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
