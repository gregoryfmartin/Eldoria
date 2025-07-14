using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEFIREFLYJAR
#
###############################################################################

Class BEFireflyJar : BEJewelry {
	BEFireflyJar() : base() {
		$this.Name               = 'Firefly Jar'
		$this.MapObjName         = 'fireflyjar'
		$this.PurchasePrice      = 650
		$this.SellPrice          = 325
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A miniature jar containing perpetually glowing fireflies.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Unisex
	}
}
