using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDESERTWANDERERSROBE
#
###############################################################################

Class BEDesertWanderersRobe : BEArmor {
	BEDesertWanderersRobe() : base() {
		$this.Name               = 'Desert Wanderer''s Robe'
		$this.MapObjName         = 'desertwanderersrobe'
		$this.PurchasePrice      = 190
		$this.SellPrice          = 95
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 7
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A light, breathable robe ideal for hot climates, offers minor sun protection.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
