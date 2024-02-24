Enum GameStatePrimary {
    SplashScreenA
    SplashScreenB
    TitleScreen
    PlayerSetupScreen
    GamePlayScreen
    InventoryScreen
    BattleScreen
    PlayerStatusScreen
    Cleanup
}

Enum GameStateSecondary {
    Normal
    Battle
    Shop
    Inn
}

Enum StatNumberState {
    Normal
    Caution
    Danger
}

Enum CommonVirtualKeyCodes {
    Escape     = 27
    LeftArrow  = 37
    RightArrow = 39
    UpArrow    = 38
    DownArrow  = 40
    A          = 65
    D          = 68
    Enter      = 13
}

Enum ItemRemovalStatus {
    Success
    FailGeneral
    FailKeyItem
}

Enum ActionInvRemovalStatus {
    Success
    Fail
}

Enum BattleActionType {
    Physical
    ElementalFire
    ElementalWater
    ElementalEarth
    ElementalWind
    ElementalLight
    ElementalDark
    ElementalIce
    MagicPoison
    MagicConfuse
    MagicSleep
    MagicAging
    MagicHealing
    MagicStatAugment
    None
}

Enum HpIncrementResult {
    FailHpFull
    FailHpAddNegative
    Success
}

Enum HpDecrementResult {
    FailHpEmpty
    FailHpSubtractPositive
    Success
}

Enum MpIncrementResult {
    FailMpFull
    FailMpAddNegative
    Success
}

Enum MpDecrementResult {
    FailMpEmpty
    FailMpSubtractPositive
    Success
}

Enum StatId {
    HitPoints
    MagicPoints
    Attack
    Defense
    MagicAttack
    MagicDefense
    Speed
    Luck
    Accuracy
}

Enum ActionSlot {
    A
    B
    C
    D
    None
}

Enum AllActions {
    Pound
    KarateChop
    DoubleSlap
    CometPunch
    MegaPunch
    PayDay
    FirePunch
    IcePunch
    ThunderPunch
    Scratch
    ViseGrip
    Guillotine
    RazorWind
    SwordsDance
    Cut
    Gust
    WingAttack
    Whirlwind
    Fly
    Bind
    Slam
    VineWhip
    Stomp
    DoubleKick
    MegaKick
    JumpKick
    RollingKick
    SandAttack
}

Enum BattleManagerState {
    HealthCheck
    TurnIncrement
    PhaseOrdering
    PhaseAExecution
    PhaseBExecution
    Calculation
    BattleWon
    BattleLost
}

Enum BattleActionResultType {
    Success
    SuccessWithCritical
    SuccessWithAffinityBonus
    SuccessWithCritAndAffinityBonus
    FailedAttackMissed
    FailedAttackFailed
    FailedElementalMatch
    FailedNoUsesRemaining
    FailedNotEnoughMp
}

Enum StatusScreenMode {
    EquippedTechSelection
    TechInventorySelection
}