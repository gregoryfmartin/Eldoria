using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BENECROTICBOOTS
#
###############################################################################

Class BENecroticBoots : BEBoots {
	BENecroticBoots() : base() {
		$this.Name               = 'Necrotic Boots'
		$this.MapObjName         = 'necroticboots'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{
			[StatId]::Defense = 43
			[StatId]::MagicDefense = 27
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots linked to death magic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
