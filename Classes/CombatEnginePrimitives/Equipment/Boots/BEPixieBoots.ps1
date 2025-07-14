using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEPIXIEBOOTS
#
###############################################################################

Class BEPixieBoots : BEBoots {
	BEPixieBoots() : base() {
		$this.Name               = 'Pixie Boots'
		$this.MapObjName         = 'pixieboots'
		$this.PurchasePrice      = 130
		$this.SellPrice          = 65
		$this.TargetStats        = @{
			[StatId]::Defense = 4
			[StatId]::MagicDefense = 9
			[StatId]::Speed = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Tiny and almost weightless boots.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Female
	}
}
