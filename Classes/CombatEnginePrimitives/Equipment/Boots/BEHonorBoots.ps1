using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEHONORBOOTS
#
###############################################################################

Class BEHonorBoots : BEBoots {
	BEHonorBoots() : base() {
		$this.Name               = 'Honor Boots'
		$this.MapObjName         = 'honorboots'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{
			[StatId]::Defense = 42
			[StatId]::MagicDefense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots symbolizing integrity.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
