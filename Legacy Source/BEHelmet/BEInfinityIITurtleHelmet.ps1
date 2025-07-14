using namespace System

Set-StrictMode -Version Latest

###############################################################################
#
# BE BEINFINITYIITURTLEHELMET
#
###############################################################################

Class BEInfinityIITurtleHelmet : BEHelmet {
    BEInfinityIITurtleHelmet() : base() {
        $this.Name               = 'Infinity II Turtle Helmet'
        $this.MapObjName         = 'infinityiiturttlehelmet'
        $this.PurchasePrice      = 250000
        $this.SellPrice          = 0
        $this.TargetStats        = @{
            [StatId]::Defense      = 250
            [StatId]::MagicDefense = 250
        }
        $this.CanAddToInventory  = $true
        $this.ExamineString      = 'When someone attacks you, that means it spawns 60K turtles!'
        $this.PlayerEffectString = "+$($this.TargetStats[[StatId]::Defense]) DEF  +$($this.TargetStats[[StatId]::MagicDefense]) MDF"
        $this.TargetGender       = [Gender]::Unisex
    }
}
