using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEZOMBIESBRAINBUCKET
#
###############################################################################

Class BEZombiesBrainBucket : BEHelmet {
	BEZombiesBrainBucket() : base() {
		$this.Name               = 'Zombie''s Brain Bucket'
		$this.MapObjName         = 'zombiesbrainbucket'
		$this.PurchasePrice      = 100
		$this.SellPrice          = 50
		$this.TargetStats        = @{
			[StatId]::Defense = 3
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'A gruesome bucket worn by zombies, protecting their brains.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
