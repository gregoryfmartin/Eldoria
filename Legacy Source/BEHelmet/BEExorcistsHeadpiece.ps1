using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEEXORCISTSHEADPIECE
#
###############################################################################

Class BEExorcistsHeadpiece : BEHelmet {
	BEExorcistsHeadpiece() : base() {
		$this.Name               = 'Exorcist''s Headpiece'
		$this.MapObjName         = 'exorcistsheadpiece'
		$this.PurchasePrice      = 180
		$this.SellPrice          = 90
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 9
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A holy headpiece worn by exorcists, warding off demonic influence.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
