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

[Hashtable]$BattleEntityStatsTable = @{}
[Hashtable]$BattleEntityPropertyTable = @{}
[Hashtable]$BattleEntityTable = @{}