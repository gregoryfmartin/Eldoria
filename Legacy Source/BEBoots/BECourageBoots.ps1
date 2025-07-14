using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECOURAGEBOOTS
#
###############################################################################

Class BECourageBoots : BEBoots {
	BECourageBoots() : base() {
		$this.Name               = 'Courage Boots'
		$this.MapObjName         = 'courageboots'
		$this.PurchasePrice      = 550
		$this.SellPrice          = 275
		$this.TargetStats        = @{
			[StatId]::Defense = 18
			[StatId]::MagicDefense = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots that instill bravery.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
