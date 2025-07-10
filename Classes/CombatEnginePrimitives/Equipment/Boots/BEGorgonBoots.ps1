using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGORGONBOOTS
#
###############################################################################

Class BEGorgonBoots : BEBoots {
	BEGorgonBoots() : base() {
		$this.Name               = 'Gorgon Boots'
		$this.MapObjName         = 'gorgonboots'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{
			[StatId]::Defense = 40
			[StatId]::MagicDefense = 22
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots offering protection from petrification.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
