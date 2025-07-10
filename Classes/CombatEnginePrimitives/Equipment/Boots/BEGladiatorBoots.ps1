using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEGLADIATORBOOTS
#
###############################################################################

Class BEGladiatorBoots : BEBoots {
	BEGladiatorBoots() : base() {
		$this.Name               = 'Gladiator Boots'
		$this.MapObjName         = 'gladiatorboots'
		$this.PurchasePrice      = 620
		$this.SellPrice          = 310
		$this.TargetStats        = @{
			[StatId]::Defense = 33
			[StatId]::MagicDefense = 7
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Heavy boots worn by arena champions.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
