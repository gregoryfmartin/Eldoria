using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BECHAOSFRAGMENTHELM
#
###############################################################################

Class BEChaosFragmentHelm : BEHelmet {
	BEChaosFragmentHelm() : base() {
		$this.Name               = 'Chaos Fragment Helm'
		$this.MapObjName         = 'chaosfragmenthelm'
		$this.PurchasePrice      = 3200
		$this.SellPrice          = 1600
		$this.TargetStats        = @{
			[StatId]::Defense = 20
			[StatId]::MagicDefense = 20
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A chaotic helm formed from fragments of pure chaos, granting unpredictable power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
