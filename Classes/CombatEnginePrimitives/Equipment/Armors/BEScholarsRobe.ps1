using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESCHOLARSROBE
#
###############################################################################

Class BEScholarsRobe : BEArmor {
	BEScholarsRobe() : base() {
		$this.Name               = 'Scholar''s Robe'
		$this.MapObjName         = 'scholarsrobe'
		$this.PurchasePrice      = 130
		$this.SellPrice          = 65
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 13
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A comfortable robe for long hours of study.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
