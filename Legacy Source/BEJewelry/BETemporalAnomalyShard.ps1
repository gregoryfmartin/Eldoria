using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BETEMPORALANOMALYSHARD
#
###############################################################################

Class BETemporalAnomalyShard : BEJewelry {
	BETemporalAnomalyShard() : base() {
		$this.Name               = 'Temporal Anomaly Shard'
		$this.MapObjName         = 'temporalanomalyshard'
		$this.PurchasePrice      = 2400
		$this.SellPrice          = 1200
		$this.TargetStats        = @{
			[StatId]::Speed = 8
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A shard that seems to slightly distort time around it.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Speed]) SPD"
		$this.TargetGender       = [Gender]::Unisex
	}
}
