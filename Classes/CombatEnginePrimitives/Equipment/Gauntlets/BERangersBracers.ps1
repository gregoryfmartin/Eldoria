using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BERANGERSBRACERS
#
###############################################################################

Class BERangersBracers : BEGauntlets {
	BERangersBracers() : base() {
		$this.Name               = 'Ranger''s Bracers'
		$this.MapObjName         = 'rangersbracers'
		$this.PurchasePrice      = 260
		$this.SellPrice          = 130
		$this.TargetStats        = @{
			[StatId]::Defense = 9
			[StatId]::MagicDefense = 8
			[StatId]::Accuracy = 6
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Light bracers for those who roam the wilderness.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF  +$($this.TargetStats[[StatId]::Accuracy]) ACC"
		$this.TargetGender       = [Gender]::Unisex
	}
}
