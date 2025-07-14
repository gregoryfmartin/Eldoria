using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEFORTUNETELLERSROBE
#
###############################################################################

Class BEFortuneTellersRobe : BEArmor {
	BEFortuneTellersRobe() : base() {
		$this.Name               = 'Fortune Teller''s Robe'
		$this.MapObjName         = 'fortunetellersrobe'
		$this.PurchasePrice      = 700
		$this.SellPrice          = 350
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 21
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A colorful robe with mystical symbols, enhances foresight.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
