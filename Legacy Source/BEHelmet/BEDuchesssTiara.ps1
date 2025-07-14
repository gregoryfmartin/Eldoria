using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDUCHESSSTIARA
#
###############################################################################

Class BEDuchesssTiara : BEHelmet {
	BEDuchesssTiara() : base() {
		$this.Name               = 'Duchess''s Tiara'
		$this.MapObjName         = 'duchessstiara'
		$this.PurchasePrice      = 600
		$this.SellPrice          = 300
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 8
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A sophisticated tiara worn by duchesses, befitting their noble status.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
