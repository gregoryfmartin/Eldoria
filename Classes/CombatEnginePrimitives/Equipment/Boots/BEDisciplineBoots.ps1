using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEDISCIPLINEBOOTS
#
###############################################################################

Class BEDisciplineBoots : BEBoots {
	BEDisciplineBoots() : base() {
		$this.Name               = 'Discipline Boots'
		$this.MapObjName         = 'disciplineboots'
		$this.PurchasePrice      = 370
		$this.SellPrice          = 185
		$this.TargetStats        = @{
			[StatId]::Defense = 10
			[StatId]::MagicDefense = 16
		}
		$this.CanAddToInventory  = $true
		$this.ExamineString      = 'Boots that promote self-control.'
		$this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
		$this.TargetGender       = [Gender]::Unisex
	}
}
