using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEHOPEBOOTS
#
###############################################################################

Class BEHopeBoots : BEBoots {
	BEHopeBoots() : base() {
		$this.Name               = 'Hope Boots'
		$this.MapObjName         = 'hopeboots'
		$this.PurchasePrice      = 700
		$this.SellPrice          = 350
		$this.TargetStats        = @{
			[StatId]::Defense = 25
			[StatId]::MagicDefense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots that inspire optimism.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
