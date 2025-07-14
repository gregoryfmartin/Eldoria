using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEBRIGANDSBRACERS
#
###############################################################################

Class BEBrigandsBracers : BEGauntlets {
	BEBrigandsBracers() : base() {
		$this.Name               = 'Brigand''s Bracers'
		$this.MapObjName         = 'brigandsbracers'
		$this.PurchasePrice      = 130
		$this.SellPrice          = 65
		$this.TargetStats        = @{
			[StatId]::Defense = 6
			[StatId]::MagicDefense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Simple bracers, often found on bandits.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
