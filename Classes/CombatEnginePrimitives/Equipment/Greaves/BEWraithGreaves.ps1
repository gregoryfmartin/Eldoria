using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEWRAITHGREAVES
#
###############################################################################

Class BEWraithGreaves : BEGreaves {
	BEWraithGreaves() : base() {
		$this.Name               = 'Wraith Greaves'
		$this.MapObjName         = 'wraithgreaves'
		$this.PurchasePrice      = 1100
		$this.SellPrice          = 550
		$this.TargetStats        = @{
			[StatId]::Defense = 32
			[StatId]::MagicDefense = 45
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Greaves of a malevolent specter.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
