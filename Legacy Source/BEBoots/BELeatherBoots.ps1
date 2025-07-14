using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BELEATHERBOOTS
#
###############################################################################

Class BELeatherBoots : BEBoots {
	BELeatherBoots() : base() {
		$this.Name               = 'Leather Boots'
		$this.MapObjName         = 'leatherboots'
		$this.PurchasePrice      = 80
		$this.SellPrice          = 40
		$this.TargetStats        = @{
			[StatId]::Defense = 3
			[StatId]::MagicDefense = 1
			[StatId]::Speed = 1
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Basic leather boots, offering minimal protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Unisex
	}
}
