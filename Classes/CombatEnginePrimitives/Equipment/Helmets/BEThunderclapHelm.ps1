using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE THUNDERCLAP HELM
#
###############################################################################

Class BEThunderclapHelm : BEHelmet {
	BEThunderclapHelm() : base() {
		$this.Name               = 'Thunderclap Helm'
		$this.MapObjName         = 'thunderclaphelm'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{
			[StatId]::Defense = 13
			[StatId]::MagicDefense = 9
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm infused with storm energy, allowing the wearer to channel lightning.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
