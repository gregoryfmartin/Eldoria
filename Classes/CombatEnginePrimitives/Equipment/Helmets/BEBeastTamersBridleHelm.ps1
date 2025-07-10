using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEBEASTTAMERSBRIDLEHELM
#
###############################################################################

Class BEBeastTamersBridleHelm : BEHelmet {
	BEBeastTamersBridleHelm() : base() {
		$this.Name               = 'Beast Tamer''s Bridle Helm'
		$this.MapObjName         = 'beasttamersbridlehelm'
		$this.PurchasePrice      = 1500
		$this.SellPrice          = 750
		$this.TargetStats        = @{
			[StatId]::Defense = 5
			[StatId]::MagicDefense = 10
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A unique helm that aids in taming wild beasts.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
