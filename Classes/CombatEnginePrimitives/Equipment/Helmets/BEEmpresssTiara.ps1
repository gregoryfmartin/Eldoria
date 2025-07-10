using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEEMPRESSSTIARA
#
###############################################################################

Class BEEmpresssTiara : BEHelmet {
	BEEmpresssTiara() : base() {
		$this.Name               = 'Empress''s Tiara'
		$this.MapObjName         = 'empressstiara'
		$this.PurchasePrice      = 2800
		$this.SellPrice          = 1400
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A regal tiara worn by empresses, radiating grace and authority.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
