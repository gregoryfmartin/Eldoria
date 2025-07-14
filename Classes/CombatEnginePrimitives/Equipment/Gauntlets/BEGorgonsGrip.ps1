using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGORGONSGRIP
#
###############################################################################

Class BEGorgonsGrip : BEGauntlets {
	BEGorgonsGrip() : base() {
		$this.Name               = 'Gorgon''s Grip'
		$this.MapObjName         = 'gorgonsgrip'
		$this.PurchasePrice      = 950
		$this.SellPrice          = 475
		$this.TargetStats        = @{
			[StatId]::Defense = 45
			[StatId]::MagicDefense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Petrifying gauntlets that can turn foes to stone.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
