using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE KRAKEN TENTACLE HELM
#
###############################################################################

Class BEKrakenTentacleHelm : BEHelmet {
	BEKrakenTentacleHelm() : base() {
		$this.Name               = 'Kraken Tentacle Helm'
		$this.MapObjName         = 'krakententaclehelm'
		$this.PurchasePrice      = 1700
		$this.SellPrice          = 850
		$this.TargetStats        = @{
			[StatId]::Defense = 10
			[StatId]::MagicDefense = 13
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A strange helm made from kraken tentacles, allowing some control over water.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
