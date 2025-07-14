using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEENGINEERBOOTS
#
###############################################################################

Class BEEngineerBoots : BEBoots {
	BEEngineerBoots() : base() {
		$this.Name               = 'Engineer Boots'
		$this.MapObjName         = 'engineerboots'
		$this.PurchasePrice      = 450
		$this.SellPrice          = 225
		$this.TargetStats        = @{
			[StatId]::Defense = 18
			[StatId]::MagicDefense = 9
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of mechanical innovators.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
