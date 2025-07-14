using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEVAMPIREBOOTS
#
###############################################################################

Class BEVampireBoots : BEBoots {
	BEVampireBoots() : base() {
		$this.Name               = 'Vampire Boots'
		$this.MapObjName         = 'vampireboots'
		$this.PurchasePrice      = 850
		$this.SellPrice          = 425
		$this.TargetStats        = @{
			[StatId]::Defense = 32
			[StatId]::MagicDefense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots that drain life from foes.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
