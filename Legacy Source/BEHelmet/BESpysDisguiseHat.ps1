using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESPYSDISGUISEHAT
#
###############################################################################

Class BESpysDisguiseHat : BEHelmet {
	BESpysDisguiseHat() : base() {
		$this.Name               = 'Spy''s Disguise Hat'
		$this.MapObjName         = 'spysdisguisehat'
		$this.PurchasePrice      = 40
		$this.SellPrice          = 20
		$this.TargetStats        = @{
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A simple hat used by spies to blend into crowds.'
		$this.PlayerEffectString = ""
		$this.TargetGender       = [Gender]::Unisex
	}
}
