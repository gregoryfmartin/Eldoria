using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE NECROMANCER'S HOOD
#
###############################################################################

Class BENecromancersHood : BEHelmet {
	BENecromancersHood() : base() {
		$this.Name               = 'Necromancer''s Hood'
		$this.MapObjName         = 'necromancershood'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{
			[StatId]::Defense = 5
			[StatId]::MagicDefense = 16
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A dark, tattered hood worn by necromancers, enhancing their control over the undead.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
