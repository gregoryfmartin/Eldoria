using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE INVENTOR'S HELM
#
###############################################################################

Class BEInventorsHelm : BEHelmet {
	BEInventorsHelm() : base() {
		$this.Name               = 'Inventor''s Helm'
		$this.MapObjName         = 'inventorshelm'
		$this.PurchasePrice      = 1800
		$this.SellPrice          = 900
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 18
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm that inspires grand inventions and complex designs.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
