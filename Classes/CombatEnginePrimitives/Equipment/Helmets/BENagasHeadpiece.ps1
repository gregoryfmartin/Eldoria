using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BENAGASHEADPIECE
#
###############################################################################

Class BENagasHeadpiece : BEHelmet {
	BENagasHeadpiece() : base() {
		$this.Name               = 'Naga''s Headpiece'
		$this.MapObjName         = 'nagasheadpiece'
		$this.PurchasePrice      = 800
		$this.SellPrice          = 400
		$this.TargetStats        = @{
			[StatId]::Defense = 8
			[StatId]::MagicDefense = 6
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A serpentine headpiece worn by naga, enhancing their aquatic abilities.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
