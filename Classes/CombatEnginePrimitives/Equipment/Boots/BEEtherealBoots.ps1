using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEETHEREALBOOTS
#
###############################################################################

Class BEEtherealBoots : BEBoots {
	BEEtherealBoots() : base() {
		$this.Name               = 'Ethereal Boots'
		$this.MapObjName         = 'etherealboots'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{
			[StatId]::Defense = 32
			[StatId]::MagicDefense = 43
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots existing between realms, difficult to perceive.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
