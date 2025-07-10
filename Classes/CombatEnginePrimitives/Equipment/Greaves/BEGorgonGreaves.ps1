using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGORGONGREAVES
#
###############################################################################

Class BEGorgonGreaves : BEGreaves {
	BEGorgonGreaves() : base() {
		$this.Name               = 'Gorgon Greaves'
		$this.MapObjName         = 'gorgongreaves'
		$this.PurchasePrice      = 1200
		$this.SellPrice          = 600
		$this.TargetStats        = @{
			[StatId]::Defense = 45
			[StatId]::MagicDefense = 25
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves offering protection from petrification.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
