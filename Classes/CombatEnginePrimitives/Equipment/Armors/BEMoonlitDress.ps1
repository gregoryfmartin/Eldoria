using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEMOONLITDRESS
#
###############################################################################

Class BEMoonlitDress : BEArmor {
	BEMoonlitDress() : base() {
		$this.Name               = 'Moonlit Dress'
		$this.MapObjName         = 'moonlitdress'
		$this.PurchasePrice      = 750
		$this.SellPrice          = 375
		$this.TargetStats        = @{
			[StatId]::MagicDefense = 23
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A flowing dress that glows softly in the moonlight, enhancing illusion magic.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Female
	}
}
