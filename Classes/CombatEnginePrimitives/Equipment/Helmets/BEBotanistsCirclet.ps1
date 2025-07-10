using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEBOTANISTSCIRCLET
#
###############################################################################

Class BEBotanistsCirclet : BEHelmet {
	BEBotanistsCirclet() : base() {
		$this.Name               = 'Botanist''s Circlet'
		$this.MapObjName         = 'botanistscirclet'
		$this.PurchasePrice      = 110
		$this.SellPrice          = 55
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 5
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A circlet that enhances a botanist''s knowledge of plants and their properties.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
