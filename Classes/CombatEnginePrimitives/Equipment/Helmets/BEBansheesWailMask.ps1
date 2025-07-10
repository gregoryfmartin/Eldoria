using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEBANSHEESWAILMASK
#
###############################################################################

Class BEBansheesWailMask : BEHelmet {
	BEBansheesWailMask() : base() {
		$this.Name               = 'Banshee''s Wail Mask'
		$this.MapObjName         = 'bansheeswailmask'
		$this.PurchasePrice      = 1600
		$this.SellPrice          = 800
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 17
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A haunting mask that amplifies a banshee''s terrifying scream.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
