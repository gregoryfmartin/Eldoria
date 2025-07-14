using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESOULBOUNDPAULDRON
#
###############################################################################

Class BESoulboundPauldron : BEPauldron {
	BESoulboundPauldron() : base() {
		$this.Name               = 'Soulbound Pauldron'
		$this.MapObjName         = 'soulboundpauldron'
		$this.PurchasePrice      = 1350
		$this.SellPrice          = 675
		$this.TargetStats        = @{
			[StatId]::Defense = 27
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Binds to its wearer, enhancing their fighting prowess.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Male
	}
}
