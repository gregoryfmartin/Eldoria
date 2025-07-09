using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE MANTICORE SPIKE HELM
#
###############################################################################

Class BEManticoreSpikeHelm : BEHelmet {
	BEManticoreSpikeHelm() : base() {
		$this.Name               = 'Manticore Spike Helm'
		$this.MapObjName         = 'manticorespikehelm'
		$this.PurchasePrice      = 1750
		$this.SellPrice          = 875
		$this.TargetStats        = @{
			[StatId]::Defense = 16
			[StatId]::MagicDefense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A spiky helm made from manticore spikes, inflicting poison on attackers.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
