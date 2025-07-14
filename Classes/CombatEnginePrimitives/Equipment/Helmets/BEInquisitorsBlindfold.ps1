using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEINQUISITORSBLINDFOLD
#
###############################################################################

Class BEInquisitorsBlindfold : BEHelmet {
	BEInquisitorsBlindfold() : base() {
		$this.Name               = 'Inquisitor''s Blindfold'
		$this.MapObjName         = 'inquisitorsblindfold'
		$this.PurchasePrice      = 170
		$this.SellPrice          = 85
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 7
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A blindfold worn by certain inquisitors, allowing them to focus on inner vision.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
