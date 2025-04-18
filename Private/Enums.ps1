Set-StrictMode -Version Latest

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

Enum StatNumberState {
    Normal
    Caution
    Danger
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

Enum FnlNoiseType {
    OpenSimplex2
    OpenSimplex2S
    Cellular
    Perlin
    ValueCubic
    Value
}

Enum FnlRotationType3D {
    None
    ImproveXYPlanes
    ImproveXZPlanes
}

Enum FnlFractalType {
    None
    FBm
    Ridged
    PingPong
    DomainWarpProgressive
    DomainWarpIndependent
}

Enum FnlCellularDistanceFunction {
    Euclidean
    EuclideanSq
    Manhattan
    Hybrid
}

Enum FnlCellularReturnType {
    CellValue
    Distance
    Distance2
    Distance2Add
    Distance2Sub
    Distance2Mul
    Distance2Div
}

Enum FnlDomainWarpType {
    OpenSimplex2
    OpenSimplex2Reduced
    BasicGrid
}

Enum FnlTransformType3D {
    None
    ImproveXYPlanes
    ImproveXZPlanes
    DefaultOpenSimplex2
}