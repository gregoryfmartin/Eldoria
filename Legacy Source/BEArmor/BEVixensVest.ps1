using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEVIXENSVEST
#
###############################################################################

Class BEVixensVest : BEArmor {
	BEVixensVest() : base() {
		$this.Name               = 'Vixen''s Vest'
		$this.MapObjName         = 'vixensvest'
		$this.PurchasePrice      = 250
		$this.SellPrice          = 125
		$this.TargetStats        = @{
			[StatId]::Defense = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A sleek, dark vest, often worn by agile and cunning female rogues.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Female
	}
}
