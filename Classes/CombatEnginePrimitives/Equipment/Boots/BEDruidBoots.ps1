using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDRUIDBOOTS
#
###############################################################################

Class BEDruidBoots : BEBoots {
	BEDruidBoots() : base() {
		$this.Name               = 'Druid Boots'
		$this.MapObjName         = 'druidboots'
		$this.PurchasePrice      = 530
		$this.SellPrice          = 265
		$this.TargetStats        = @{
			[StatId]::Defense = 16
			[StatId]::MagicDefense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots made from natural materials, attuned to nature.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
