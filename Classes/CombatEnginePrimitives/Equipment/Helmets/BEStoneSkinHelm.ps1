using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE STONE SKIN HELM
#
###############################################################################

Class BEStoneSkinHelm : BEHelmet {
	BEStoneSkinHelm() : base() {
		$this.Name               = 'Stone Skin Helm'
		$this.MapObjName         = 'stoneskinhelm'
		$this.PurchasePrice      = 1700
		$this.SellPrice          = 850
		$this.TargetStats        = @{
			[StatId]::Defense = 12
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A helm that turns the wearer''s skin to stone, providing immense defense.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
