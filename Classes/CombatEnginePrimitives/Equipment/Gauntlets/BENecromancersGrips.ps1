using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BENECROMANCERSGRIPS
#
###############################################################################

Class BENecromancersGrips : BEGauntlets {
	BENecromancersGrips() : base() {
		$this.Name               = 'Necromancer''s Grips'
		$this.MapObjName         = 'necromancersgrips'
		$this.PurchasePrice      = 800
		$this.SellPrice          = 400
		$this.TargetStats        = @{
			[StatId]::Defense = 11
			[StatId]::MagicDefense = 30
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Grips that draw power from the deceased.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
