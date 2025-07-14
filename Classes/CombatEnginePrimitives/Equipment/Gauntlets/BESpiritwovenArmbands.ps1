using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESPIRITWOVENARMBANDS
#
###############################################################################

Class BESpiritwovenArmbands : BEGauntlets {
	BESpiritwovenArmbands() : base() {
		$this.Name               = 'Spiritwoven Armbands'
		$this.MapObjName         = 'spiritwovenarmbands'
		$this.PurchasePrice      = 720
		$this.SellPrice          = 360
		$this.TargetStats        = @{
			[StatId]::Defense = 16
			[StatId]::MagicDefense = 33
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Armbands intricately woven with spiritual energy.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
