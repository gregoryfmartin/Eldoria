using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE VAMPIRE'S COFFIN LID HELM
#
###############################################################################

Class BEVampiresCoffinLidHelm : BEHelmet {
	BEVampiresCoffinLidHelm() : base() {
		$this.Name               = 'Vampire''s Coffin Lid Helm'
		$this.MapObjName         = 'vampirescoffinlidhelm'
		$this.PurchasePrice      = 2400
		$this.SellPrice          = 1200
		$this.TargetStats        = @{
			[StatId]::Defense = 18
			[StatId]::MagicDefense = 15
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A macabre helm fashioned from a coffin lid, granting life-draining abilities.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
