using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE OBSIDIAN GREATSWORD
#
###############################################################################

Class BEObsidianGreatsword : BEWeapon {
	BEObsidianGreatsword() : base() {
		$this.Name          = 'Obsidian Greatsword'
		$this.MapObjName    = 'obsidiangreatsword'
		$this.PurchasePrice = 1000
		$this.SellPrice     = 500
		$this.TargetStats   = @{
			[StatId]::Attack = 57
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A massive sword forged from volcanic glass, incredibly sharp.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Attack]) ATK"
		$this.TargetGender       = [Gender]::Unisex
	}
}
