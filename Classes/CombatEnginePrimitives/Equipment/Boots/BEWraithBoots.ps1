using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEWRAITHBOOTS
#
###############################################################################

Class BEWraithBoots : BEBoots {
	BEWraithBoots() : base() {
		$this.Name               = 'Wraith Boots'
		$this.MapObjName         = 'wraithboots'
		$this.PurchasePrice      = 1000
		$this.SellPrice          = 500
		$this.TargetStats        = @{
			[StatId]::Defense = 29
			[StatId]::MagicDefense = 40
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots of a malevolent specter.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
