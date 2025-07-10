using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEZEALOTBOOTS
#
###############################################################################

Class BEZealotBoots : BEBoots {
	BEZealotBoots() : base() {
		$this.Name               = 'Zealot Boots'
		$this.MapObjName         = 'zealotboots'
		$this.PurchasePrice      = 850
		$this.SellPrice          = 425
		$this.TargetStats        = @{
			[StatId]::Defense = 32
			[StatId]::MagicDefense = 25
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of unwavering devotion.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
