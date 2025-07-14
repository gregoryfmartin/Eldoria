using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BERANGERBOOTS
#
###############################################################################

Class BERangerBoots : BEBoots {
	BERangerBoots() : base() {
		$this.Name               = 'Ranger Boots'
		$this.MapObjName         = 'rangerboots'
		$this.PurchasePrice      = 350
		$this.SellPrice          = 175
		$this.TargetStats        = @{
			[StatId]::Defense = 14
			[StatId]::MagicDefense = 12
			[StatId]::Speed = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots suitable for wilderness survival.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Unisex
	}
}
