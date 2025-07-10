using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEMONKSHEADBAND
#
###############################################################################

Class BEMonksHeadband : BEHelmet {
	BEMonksHeadband() : base() {
		$this.Name               = 'Monk''s Headband'
		$this.MapObjName         = 'monksheadband'
		$this.PurchasePrice      = 80
		$this.SellPrice          = 40
		$this.TargetStats        = @{
			[StatId]::Defense = 2
			[StatId]::MagicDefense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A simple headband worn by monks, aiding in focus and meditation.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
