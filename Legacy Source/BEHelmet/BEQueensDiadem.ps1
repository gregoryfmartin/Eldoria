using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEQUEENSDIADEM
#
###############################################################################

Class BEQueensDiadem : BEHelmet {
	BEQueensDiadem() : base() {
		$this.Name               = 'Queen''s Diadem'
		$this.MapObjName         = 'queensdiadem'
		$this.PurchasePrice      = 2500
		$this.SellPrice          = 1250
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A beautiful diadem worn by queens, symbolizing wisdom and benevolence.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
