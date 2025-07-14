using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BETORTURERBOOTS
#
###############################################################################

Class BETorturerBoots : BEBoots {
	BETorturerBoots() : base() {
		$this.Name               = 'Torturer Boots'
		$this.MapObjName         = 'torturerboots'
		$this.PurchasePrice      = 700
		$this.SellPrice          = 350
		$this.TargetStats        = @{
			[StatId]::Defense = 27
			[StatId]::MagicDefense = 7
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of those who inflict pain.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
