using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEJUDGESWIG
#
###############################################################################

Class BEJudgesWig : BEHelmet {
	BEJudgesWig() : base() {
		$this.Name               = 'Judge''s Wig'
		$this.MapObjName         = 'judgeswig'
		$this.PurchasePrice      = 100
		$this.SellPrice          = 50
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 2
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A formal wig worn by judges, symbolizing justice and authority.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
