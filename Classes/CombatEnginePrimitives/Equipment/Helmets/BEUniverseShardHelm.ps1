using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEUNIVERSESHARDHELM
#
###############################################################################

Class BEUniverseShardHelm : BEHelmet {
	BEUniverseShardHelm() : base() {
		$this.Name               = 'Universe Shard Helm'
		$this.MapObjName         = 'universeshardhelm'
		$this.PurchasePrice      = 5500
		$this.SellPrice          = 2750
		$this.TargetStats        = @{
			[StatId]::Defense = 25
			[StatId]::MagicDefense = 45
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm made from fragments of the universe itself, granting unimaginable power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
