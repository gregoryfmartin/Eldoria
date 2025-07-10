using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECLERICBOOTS
#
###############################################################################

Class BEClericBoots : BEBoots {
	BEClericBoots() : base() {
		$this.Name               = 'Cleric Boots'
		$this.MapObjName         = 'clericboots'
		$this.PurchasePrice      = 570
		$this.SellPrice          = 285
		$this.TargetStats        = @{
			[StatId]::Defense = 18
			[StatId]::MagicDefense = 26
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots blessed by divine power, for healing.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
