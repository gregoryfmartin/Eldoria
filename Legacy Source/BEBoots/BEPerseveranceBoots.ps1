using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEPERSEVERANCEBOOTS
#
###############################################################################

Class BEPerseveranceBoots : BEBoots {
	BEPerseveranceBoots() : base() {
		$this.Name               = 'Perseverance Boots'
		$this.MapObjName         = 'perseveranceboots'
		$this.PurchasePrice      = 280
		$this.SellPrice          = 140
		$this.TargetStats        = @{
			[StatId]::Defense = 7
			[StatId]::MagicDefense = 12
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots that encourage persistence.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
