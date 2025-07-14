using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDEEPSEAROBE
#
###############################################################################

Class BEDeepSeaRobe : BEArmor {
	BEDeepSeaRobe() : base() {
		$this.Name               = 'Deep Sea Robe'
		$this.MapObjName         = 'deepsearobe'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 28
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A robe woven from rare deep-sea fibers, offers strong water resistance.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
