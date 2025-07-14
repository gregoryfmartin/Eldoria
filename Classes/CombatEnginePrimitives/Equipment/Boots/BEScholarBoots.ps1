using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESCHOLARBOOTS
#
###############################################################################

Class BEScholarBoots : BEBoots {
	BEScholarBoots() : base() {
		$this.Name               = 'Scholar Boots'
		$this.MapObjName         = 'scholarboots'
		$this.PurchasePrice      = 280
		$this.SellPrice          = 140
		$this.TargetStats        = @{
			[StatId]::Defense = 7
			[StatId]::MagicDefense = 13
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots worn by academic scholars.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
