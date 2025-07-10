using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEINFINITYVITURTLEARMOR
#
###############################################################################

Class BEInfinityVITurtleArmor : BEArmor {
    BEInfinityVITurtleArmor() : base() {
        $this.Name               = 'Infinity VI Turtle Armor'
        $this.MapObjName         = 'infinityviturtlearmor'
        $this.PurchasePrice      = 300000
        $this.SellPrice          = 0
        $this.TargetStats        = @{
            [StatId]::Defense      = 250
            [StatId]::MagicDefense = 250
        }
        $this.CanAddToInventory  = $true
        $this.ExamineString      = 'This also evidently spawns 60K turtles too.'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
        $this.TargetGender       = [Gender]::Unisex
    }
}
