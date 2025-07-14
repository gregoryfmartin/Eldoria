using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESOULFIREGRIPS
#
###############################################################################

Class BESoulfireGrips : BEGauntlets {
	BESoulfireGrips() : base() {
		$this.Name               = 'Soulfire Grips'
		$this.MapObjName         = 'soulfiregrips'
		$this.PurchasePrice      = 1500
		$this.SellPrice          = 750
		$this.TargetStats        = @{
			[StatId]::Defense = 30
			[StatId]::MagicDefense = 50
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Grips that burn with ethereal flame, searing spirits.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
