using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEILLUSIONISTSMIRRORSHARD
#
###############################################################################

Class BEIllusionistsMirrorShard : BEJewelry {
	BEIllusionistsMirrorShard() : base() {
		$this.Name               = 'Illusionist''s Mirror Shard'
		$this.MapObjName         = 'illusionistsmirrorshard'
		$this.PurchasePrice      = 1600
		$this.SellPrice          = 800
		$this.TargetStats        = @{
			[StatId]::MagicAttack = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A fragment of a mirror that reflects illusions.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::MagicAttack]) MAT"
		$this.TargetGender       = [Gender]::Unisex
	}
}
