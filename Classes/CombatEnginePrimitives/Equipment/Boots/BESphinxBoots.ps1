using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESPHINXBOOTS
#
###############################################################################

Class BESphinxBoots : BEBoots {
	BESphinxBoots() : base() {
		$this.Name               = 'Sphinx Boots'
		$this.MapObjName         = 'sphinxboots'
		$this.PurchasePrice      = 1200
		$this.SellPrice          = 600
		$this.TargetStats        = @{
			[StatId]::Defense = 45
			[StatId]::MagicDefense = 35
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of ancient wisdom and defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
