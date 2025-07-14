using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEBATTLEWORNGAUNTLETSII
#
###############################################################################

Class BEBattlewornGauntletsII : BEGauntlets {
	BEBattlewornGauntletsII() : base() {
		$this.Name               = 'Battleworn Gauntlets II'
		$this.MapObjName         = 'battleworngauntletsii'
		$this.PurchasePrice      = 800
		$this.SellPrice          = 400
		$this.TargetStats        = @{
			[StatId]::Defense = 38
			[StatId]::MagicDefense = 8
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Battleworn Gauntlets hardened by more battles, even stronger.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Male
	}
}
