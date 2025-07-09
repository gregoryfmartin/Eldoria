using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE ETHEREAL HOOD
#
###############################################################################

Class BEEtherealHood : BEHelmet {
	BEEtherealHood() : base() {
		$this.Name               = 'Ethereal Hood'
		$this.MapObjName         = 'etherealhood'
		$this.PurchasePrice      = 2000
		$this.SellPrice          = 1000
		$this.TargetStats        = @{
			[StatId]::Defense = 5
			[StatId]::MagicDefense = 16
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A shimmering hood that makes the wearer nearly invisible to the naked eye.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
