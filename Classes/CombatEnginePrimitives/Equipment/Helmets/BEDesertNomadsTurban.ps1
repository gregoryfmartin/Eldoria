using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDESERTNOMADSTURBAN
#
###############################################################################

Class BEDesertNomadsTurban : BEHelmet {
	BEDesertNomadsTurban() : base() {
		$this.Name               = 'Desert Nomad''s Turban'
		$this.MapObjName         = 'desertnomadsturban'
		$this.PurchasePrice      = 130
		$this.SellPrice          = 65
		$this.TargetStats        = @{
			[StatId]::Defense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A practical turban for desert dwellers, protecting against sand and sun.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
