using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BENECROMANCERSSKULLMASK
#
###############################################################################

Class BENecromancersSkullMask : BEHelmet {
	BENecromancersSkullMask() : base() {
		$this.Name               = 'Necromancer''s Skull Mask'
		$this.MapObjName         = 'necromancersskullmask'
		$this.PurchasePrice      = 2000
		$this.SellPrice          = 1000
		$this.TargetStats        = @{
			[StatId]::Defense = 8
			[StatId]::MagicDefense = 22
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A chilling skull mask worn by necromancers, granting greater control over the undead.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
