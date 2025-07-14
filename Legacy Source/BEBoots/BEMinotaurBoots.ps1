using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEMINOTAURBOOTS
#
###############################################################################

Class BEMinotaurBoots : BEBoots {
	BEMinotaurBoots() : base() {
		$this.Name               = 'Minotaur Boots'
		$this.MapObjName         = 'minotaurboots'
		$this.PurchasePrice      = 850
		$this.SellPrice          = 425
		$this.TargetStats        = @{
			[StatId]::Defense = 39
			[StatId]::MagicDefense = 9
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of brute strength.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
