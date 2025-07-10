using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEHARPYSFEATHEREDHELM
#
###############################################################################

Class BEHarpysFeatheredHelm : BEHelmet {
	BEHarpysFeatheredHelm() : base() {
		$this.Name               = 'Harpy''s Feathered Helm'
		$this.MapObjName         = 'harpysfeatheredhelm'
		$this.PurchasePrice      = 200
		$this.SellPrice          = 100
		$this.TargetStats        = @{
			[StatId]::Defense = 5
			[StatId]::MagicDefense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A light helm adorned with harpy feathers, granting enhanced senses.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
