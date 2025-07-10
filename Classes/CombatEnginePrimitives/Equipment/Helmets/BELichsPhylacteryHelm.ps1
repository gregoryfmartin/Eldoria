using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BELICHSPHYLACTERYHELM
#
###############################################################################

Class BELichsPhylacteryHelm : BEHelmet {
	BELichsPhylacteryHelm() : base() {
		$this.Name               = 'Lich''s Phylactery Helm'
		$this.MapObjName         = 'lichsphylacteryhelm'
		$this.PurchasePrice      = 2500
		$this.SellPrice          = 1250
		$this.TargetStats        = @{
			[StatId]::Defense = 5
			[StatId]::MagicDefense = 25
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A cursed helm containing a lich''s phylactery, granting dark powers.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
