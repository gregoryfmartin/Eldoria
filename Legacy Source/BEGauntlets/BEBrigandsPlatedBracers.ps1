using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEBRIGANDSPLATEDBRACERS
#
###############################################################################

Class BEBrigandsPlatedBracers : BEGauntlets {
	BEBrigandsPlatedBracers() : base() {
		$this.Name               = 'Brigand''s Plated Bracers'
		$this.MapObjName         = 'brigandsplatedbracers'
		$this.PurchasePrice      = 200
		$this.SellPrice          = 100
		$this.TargetStats        = @{
			[StatId]::Defense = 10
			[StatId]::MagicDefense = 4
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Heavy plated bracers favored by elite brigands.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
