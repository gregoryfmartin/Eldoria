using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BESOULEDGE
#
###############################################################################

Class BESoulEdge : BEWeapon {
	BESoulEdge() : base() {
		$this.Name          = 'Soul Edge'
		$this.MapObjName    = 'souledge'
		$this.PurchasePrice = 4900
		$this.SellPrice     = 2450
		$this.TargetStats   = @{
			[StatId]::Attack = 140
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A cursed sword that feeds on the wielder''s soul, but grants incredible power.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}
