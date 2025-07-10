using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEOFFICERBOOTS
#
###############################################################################

Class BEOfficerBoots : BEBoots {
	BEOfficerBoots() : base() {
		$this.Name               = 'Officer Boots'
		$this.MapObjName         = 'officerboots'
		$this.PurchasePrice      = 700
		$this.SellPrice          = 350
		$this.TargetStats        = @{
			[StatId]::Defense = 32
			[StatId]::MagicDefense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots worn by military officers.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
