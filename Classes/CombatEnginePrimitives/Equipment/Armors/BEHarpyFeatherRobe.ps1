using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEHARPYFEATHERROBE
#
###############################################################################

Class BEHarpyFeatherRobe : BEArmor {
	BEHarpyFeatherRobe() : base() {
		$this.Name               = 'Harpy Feather Robe'
		$this.MapObjName         = 'harpyfeatherrobe'
		$this.PurchasePrice      = 800
		$this.SellPrice          = 400
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 24
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A light robe adorned with harpy feathers, allows graceful movement.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
