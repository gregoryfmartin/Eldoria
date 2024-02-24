. .\Enums.psm1
. .\Colors.psm1

<#
Entity Data Formatting: Semi-Colon delimited list of values, starting from left to right:

BattleEntityProperty:
    Base
    BasePre
    BaseAugmentValue
    Max
    MaxPre
    MaxAugmentValue
    State
    ValidateFunction (Name Of)
    BaseAugmentActive
    MaxAugmentActive
This is keyed to the GUID of the instance.

BattleEntity:
    Name
#>

<#
Hashtable Layouts

BattleEntityStatsTable
    Key: GUID of BattleEntity that owns a particular set of stats
    Value: A Hashtable in the format of [StatId], [Guid], where [Guid] references an entry in the BattleEntityPropertyTable
EquippedBattleActionsTable
    Key: GUID of a BattleEntity that owns a particular set of actions
    Value: A Hashtable in the format of [ActionSlot], [BattleAction]
#>

[Hashtable]$BattleEntityStatsTable = @{}
[Hashtable]$BattleEntityTable      = @{}

Function New-EldBattleEntityProperty {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [Guid]$Owner,
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [String[]]$StatData
    )

    Process {
        $BattleEntityStatsTable[$Owner] = @{
            [StatId]::HitPoints    = $StatData[0],
            [StatId]::MagicPoints  = $StatData[1],
            [StatId]::Attack       = $StatData[2],
            [StatId]::Defense      = $StatData[3],
            [StatId]::MagicAttack  = $StatData[4],
            [StatId]::MagicDefense = $StatData[5],
            [StatId]::Speed        = $StatData[6],
            [StatId]::Luck         = $StatData[7],
            [StatId]::Accuracy     = $StatData[8]
        }
    }
}

Function Update-EldBattleEntityProperty {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [Guid]$EntityGuid
    )

    Process {
        
    }
}

Function New-EldBattleEntity {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [Guid]$Owner,
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [Guid]$StatsTableRef,
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [Guid]$ActionTableRef,
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [Guid]$SpoilsEffectRef,
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [Guid]$MarbleBagRef,
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [Guid]$AffinityRef,
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [String]$Name,
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [Hashtable]$NameDrawColor
    )

    Process {
        $BattleEntityTable[$Owner] = @{
            [BattleEntityPropertyKeys]::StatsTableRef   = $StatsTableRef,
            [BattleEntityPropertyKeys]::ActionTableRef  = $ActionTableRef,
            [BattleEntityPropertyKeys]::SpoilsEffectRef = $SpoilsEffectRef,
            [BattleEntityPropertyKeys]::MarbleBagRef    = $MarbleBagRef,
            [BattleEntityPropertyKeys]::AffinityRef     = $AffinityRef,
            [BattleEntityPropertyKeys]::Name            = $Name,
            [BattleEntityPropertyKeys]::NameDrawColor   = $NameDrawColor
        }
    }
}
