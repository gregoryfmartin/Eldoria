using namespace System
using namespace System.Collections
using namespace System.Collections.Generic
using namespace System.Management.Automation.Host

Set-StrictMode -Version Latest

###############################################################################
#
# THESE DEFINE THE KINDS OF QUESTLINES THAT CAN EXIST.
#
# CORE - THIS QUESTLINE IS IS CRUCIAL TO THE COMPLETION OF THE GAME'S NARRATIVE.
#        THERE SHOULD ONLY BE ONE OF THESE IN THE GAME AT ANY TIME.
# SUBPLOT - THESE QUESTLINES ARE A LITTLE MORE INVOLVED THAN SIDE QUESTS BUT
#           DON'T CONTRIBUTE TO THE COMPLETION OF THE CORE QUESTLINE.
# SIDE - THESE QUESTLINES ARE ONLY INTENDED TO CONFER CERTAIN KINDS OF REWARDS.
#        THEY'RE TYPICALLY ONE-SHOTS AND DON'T INVOLVE ANY SERIOUS OVERHEAD
#        FROM THE PLAYER.
#
###############################################################################
Enum QuestlineType {
    Core
    Subplot
    Side
    None
}

###############################################################################
#
# THE FOUNDATIONAL BLOCK OF BUILDING UP QUESTS.
#
###############################################################################
Class QuestStep {
    [Boolean]$Completed
    [String]$Summary
    [String]$Description

    QuestStep() {
        $this.Completed   = $false # UNSET THIS FLAG BY DEFAULT; THE QUESTSTEP SHOULDN'T BE COMPLETED AT THIS POINT
        $this.Summary     = ''
        $this.Description = ''
    }

    [Void]Update() {} # THIS METHOD IS INTENDED TO BE VIRTUAL AT THIS POINT
}

Class QuestReward {
    [Boolean]$Given

    QuestReward() {
        $this.Given = $false
    }

    [Void]Give() {
        $this.Given = $true # AT A MINIMUM, THIS SHOULD SET THE GIVEN FLAG TO TRUE
    }
}

Class Quest {
    [Boolean]$Active
    [Boolean]$Completed
    [Boolean]$RewardsGiven
    [List[QuestStep]]$Steps
    [List[QuestReward]]$Rewards
    [String]$Summary
    [String]$Description

    Quest() {
        $this.Active       = $false
        $this.Completed    = $false
        $this.RewardsGiven = $false
        $this.Steps        = [List[QuestStep]]::new()
        $this.Rewards      = [List[QuestReward]]::new()
        $this.Summary      = ''
        $this.Description  = ''
    }

    Quest(
        [List[QuestStep]]$Steps,
        [List[QuestReward]]$Rewards
    ) {
        $this.Active       = $false
        $this.Completed    = $false
        $this.RewardsGiven = $false
        $this.Steps        = $Steps
        $this.Rewards      = $Rewards
        $this.Summary      = ''
        $this.Description  = ''
    }

    Quest(
        [QuestStep[]]$Steps,
        [QuestReward[]]$Rewards
    ) {
        $this.Active       = $false
        $this.Completed    = $false
        $this.RewardsGiven = $false
        $this.Steps        = [List[QuestStep]]::new()
        $this.Rewards      = [List[QuestReward]]::new()
        $this.Summary      = ''
        $this.Description  = ''

        Foreach($A in $Steps) {
            $this.Steps.Add($A) | Out-Null
        }
        Foreach($A in $Rewards) {
            $this.Rewards.Add($A) | Out-Null
        }
    }

    [Void]Update() {}
}

Class LinearQuest : Quest {
    [Int]$CurrentStep

    LinearQuest() : base() {
        $this.CurrentStep = 0
    }

    LinearQuest(
        [List[QuestStep]]$Steps,
        [List[QuestReward]]$Rewards
    ) : base($Steps, $Rewards) {
        $this.CurrentStep = 0
    }

    LinearQuest(
        [QuestStep[]]$Steps,
        [QuestReward[]]$Rewards
    ) : base($Steps, $Rewards) {
        $this.CurrentStep = 0
    }

    [QuestStep]GetCurrentStep() {
        Return $this.Steps[$this.CurrentStep]
    }

    [Void]Update() {
        If($this.Active -EQ $true) { # IS THIS QUEST'S ACTIVE FLAG SET?
            If($this.Completed -EQ $false) { # HAS THIS QUEST'S COMPLETE FLAG NOT YET BEEN SET?
                If($this.CurrentStep -LT $this.Steps.Count) { # IS THE CURRENT STEP COUNTER LESS THAN THE TOTAL NUMBER OF STEPS (INCLUSIVE)?
                    $this.Steps[$this.CurrentStep].Update() # UPDATE THE CURRENT STEP (SETS THE STEP'S COMPLETED FLAG IF HEURISTICS ARE SATISFIED)
                    If($this.Steps[$this.CurrentStep].Completed -EQ $true) { # AFTER HAVING CALLED UPDATE, HAS THE STEP'S COMPLETED FLAG BEEN SET?
                        $this.CurrentStep++ # YES, INCREMENT THE CURRENTSTEP COUNTER
                    }
                }

                If($this.CurrentStep -GE $this.Steps.Count) { # IF($THIS.CURRENTSTEP -LT $THIS.STEPS.COUNT)
                    # THIS IS A REALLY POOR MAN'S WAY OF CONCEDING THAT THE COMPLETION
                    # HAS BEEN MET, BUT GIVEN THAT THE CURRENTSTEP WOULDN'T INCREMENT
                    # UNLESS THE STEP COMPLETION FLAG HAD BEEN SET, IT SHOULD BE SANE
                    # TO ASSUME THAT ALL QUEST STEPS ARE COMPLETED BY THIS POINT.
                    $this.Completed = $true
                }
            }
            
            If($this.Completed -EQ $true) { # IF($THIS.COMPLETED -EQ $FALSE)
                If($this.RewardsGiven -EQ $false) { # HAS THE REWARDSGIVEN FLAG NOT YET BEEN SET?
                    # THE CODE HERE IS SIMILAR TO WHAT'S IN NONLINEAR QUEST.
                    # READ THAT FOR MORE DETAILS.
                    Foreach($R in $this.Rewards) { # LOOP THROUGH ALL THE ELEMENTS IN THE REWARDS CONTAINER
                        If($R.Given -EQ $false) { # HAS THIS ELEMENT'S GIVEN FLAG NOT YET BEEN SET?
                            $R.Give() # NO - EXECUTE THE ELEMENT'S GIVE METHOD (SETS THIS ELEMENT'S GIVEN FLAG)
                        }
                    }

                    $this.RewardsGiven = $true # SET THE REWARDSGIVEN FLAG
                    $this.Active       = $false # UNSET THE ACTIVE FLAG
                } # IF($THIS.REWARDSGIVEN -EQ $FALSE)
            } # IF($THIS.COMPLETED -EQ $FALSE)
        } # IF($THIS.ACTIVE -EQ $TRUE)
    } # END UPDATE METHOD DEFINITION
}

Class NonlinearQuest : Quest {
    NonlinearQuest() : base() {}

    NonlinearQuest(
        [List[QuestStep]]$Steps,
        [List[QuestReward]]$Rewards
    ) : base($Steps, $Rewards) {}

    NonlinearQuest(
        [QuestStep[]]$Steps,
        [QuestReward[]]$Rewards
    ) : base($Steps, $Rewards) {}

    [Void]Update() {
        If($this.Active -EQ $true) { # IS THIS QUEST'S ACTIVE FLAG SET?
            If($this.Completed -EQ $false) { # HAS THIS QUEST'S COMPLETE FLAG NOT YET BEEN SET?
                [Int]$A = 0 # INITIALIZE A "TRUE" COUNTER

                Foreach($Q in $this.Steps) {
                    If($Q.Completed -EQ $false) { # HAS THE STEP'S COMPLETED FLAG NOT YET BEEN SET?
                        $Q.Update() # IF NOT, CALL THE STEP'S UPDATE METHOD
                    } Else {
                        $A++ # THE STEP'S COMPLETED FLAG HAS BEEN SET, INCREMENT THE "TRUE" COUNTER
                    }
                }

                If($A -EQ $this.Steps.Count) { # DO THE NUMBER OF COMPLETED STEPS EQUAL THE NUMBER OF STEPS IN THIS QUEST?
                    $this.Completed = $true # YES, SET THE QUEST'S COMPLETED FLAG
                }
            }
            
            If($this.Completed -EQ $true) { # IF($THIS.COMPLETED -EQ $FALSE)
                If($this.RewardsGiven -EQ $false) { # HAS THE REWARDSGIVEN FLAG NOT YET BEEN SET?
                    # IT'S POSSIBLE THERE AREN'T ANY REWARDS FOR A QUEST... I SUPPOSE.
                    # REGARDLESS, IT'S BETTER TO TRY AND CATER FOR IT THAN OTHERWISE.
                    Foreach($R in $this.Rewards) { # LOOP THROUGH ALL THE ELEMENTS IN THE REWARDS CONTAINER
                        If($R.Given -EQ $false) { # HAS THIS ELEMENT'S GIVEN FLAG NOT YET BEEN SET?
                            $R.Give() # NO - EXECUTE THE ELEMENT'S GIVE METHOD (SETS THIS ELEMENT'S GIVEN FLAG)
                        }
                    }

                    # THIS MAY OR MAY NOT BE THE BEST PLACE FOR THIS,
                    # BUT AT THIS POINT, THE QUEST COULD BE CONSIDERED INACTIVE
                    # SINCE THERE'S NOTHING LEFT TO GAIN FROM IT REMAINING SO.
                    # THE CATCH HERE IS THAT EVERY QUEST SHOULD HAVE ITS REWARDSGIVEN
                    # FLAG UNSET AT TIME OF CREATION SO THAT THIS GETS PARSED.
                    $this.Active = $false
                } # IF($THIS.REWARDSGIVEN -EQ $FALSE)
            } # IF($THIS.COMPLETED -EQ $FALSE)
        } # IF($THIS.ACTIVE -EQ $TRUE)
    } # END UPDATE METHOD DEFINITION
}

Class Questline {
    [Int]$CurrentQuest
    [Boolean]$Active
    [Boolean]$Completed
    [Boolean]$RewardsGiven
    [List[Quest]]$Quests
    [List[QuestReward]]$Rewards
    [QuestlineType]$Type

    Questline() {
        # THIS CTOR MAY NOT BE ABLE TO BE USED!
        # IF A QUESTLINE IS CREATED FROM A SPLAT, THIS CTOR IS USED. THE ISSUE HERE IS THAT THE FIRST QUEST CAN'T BE SET AS ACTIVE AT THIS TIME
        # SINCE IT DOESN'T ACTUALLY EXIST IN THE LISTING AT THE TIME THIS CTOR IS CALLED, SO IT WOULD RESULT IN AN EXCEPTION.
        $this.CurrentQuest = 0
        $this.Active       = $false
        $this.Completed    = $false
        $this.RewardsGiven = $false
        $this.Quests       = [List[Quest]]::new()
        $this.Rewards      = [List[QuestReward]]::new()
        $this.Type         = [QuestlineType]::None
    }

    Questline(
        [List[Quest]]$Quests,
        [List[QuestReward]]$Rewards,
        [Boolean]$Active = $false
    ) {
        $this.CurrentQuest = 0
        $this.Active       = $Active
        $this.Completed    = $false
        $this.RewardsGiven = $false
        $this.Quests       = [List[Quest]]::new($Quests)
        $this.Rewards      = [List[QuestReward]]::new($Rewards)
        $this.Type         = [QuestlineType]::None

        $this.Quests[$this.CurrentQuest].Active = $true
    }

    Questline(
        [Quest[]]$Quests,
        [QuestReward[]]$Rewards,
        [Boolean]$Active = $false
    ) {
        $this.CurrentQuest = 0
        $this.Active       = $Active
        $this.Completed    = $false
        $this.RewardsGiven = $false
        $this.Quests       = [List[Quest]]::new()
        $this.Rewards      = [List[QuestReward]]::new()
        $this.Type         = [QuestlineType]::None

        $this.Quests[$this.CurrentQuest].Active = $true

        Foreach($A in $Quests) {
            $this.Quests.Add($A) | Out-Null
        }
        Foreach($A in $Rewards) {
            $this.Rewards.Add($A) | Out-Null
        }

        Write-Host 'Exiting Questline Tertiary Constructor...'
    }

    [Quest]GetCurrentQuest() {
        Return $this.Quests[$this.CurrentQuest]
    }

    [Void]Update() {
        # THE CODE HERE IS GOING TO LOOK AWFULLY SIMILAR TO THE CODE IN THE UPDATE
        # METHOD IN THE LINEARQUEST CLASS. WE'RE TAKING THE D OUT OF DRY BAYBEE!
        # FOR FURTHER DETAILS ON THIS BLOCK, YOU SHOULD PROBABLY LOOK AT THE
        # UPDATE METHOD IN THE QUEST CLASS. I'LL REPEAT MYSELF IN LOGIC, NOT IN
        # COMMENTS; I DO HAVE *SOME* STANDARDS.
        If($this.Active -EQ $true) { # IS THIS QUESTLINE'S ACTIVE FLAG SET?
            If($this.Completed -EQ $false) { # HAS THIS QUESTLINE'S COMPLETE FLAG NOT YET BEEN SET?
                If($this.CurrentQuest -LT $this.Quests.Count) { # IS THE CURRENT QUEST COUNTER LESS THAN THE TOTAL NUMBER OF QUESTS (INCLUSIVE)?
                    $this.Quests[$this.CurrentQuest].Update() # UPDATE THE CURRENT QUEST (SETS THE QUEST'S COMPLETED FLAG IF HEURISTICS ARE SATISFIED)

                    If($this.Quests[$this.CurrentQuest].Completed -EQ $true) { # AFTER HAVING CALLED UPDATE, HAS THE QUEST'S COMPLETED FLAG BEEN SET?
                        # CONFER THE REWARDS TO THE PLAYER (CALL UPDATE A SECOND TIME; THIS ALSO SETS THE QUESTS ACTIVE FLAG TO FALSE)
                        # Write-Host 'Quest is complete; calling its Update method again to confer rewards...'
                        # $this.Quests[$this.CurrentQuest].Update()
                        $this.CurrentQuest++ # YES, INCREMENT THE CURRENTQUEST COUNTER

                        If($this.CurrentQuest -LT $this.Quests.Count) {
                            $this.Quests[$this.CurrentQuest].Active = $true
                        }
                    }
                }

                # THERE'S A VERY SPECIFIC REASON FOR NOT USING AN ELSE FROM THE PREVIOUS CONDITIONAL; WASITNG CALL CYCLES!
                If($this.CurrentQuest -GE $this.Quests.Count) { # IF($THIS.CURRENTQUEST -LT $THIS.QUESTS.COUNT)
                    # THIS IS A REALLY POOR MAN'S WAY OF CONCEDING THAT THE COMPLETION
                    # HAS BEEN MET, BUT GIVEN THAT THE CURRENTSTEP WOULDN'T INCREMENT
                    # UNLESS THE STEP COMPLETION FLAG HAD BEEN SET, IT SHOULD BE SANE
                    # TO ASSUME THAT ALL QUEST STEPS ARE COMPLETED BY THIS POINT.
                    $this.Completed = $true
                }
            }

            # THERE'S A VERY SPECIFIC REASON FOR NOT USING AN ELSE FROM THE PREVIOUS CONDITIONAL; WASITING CALL CYCLES!
            If($this.Completed -EQ $true) { # IF($THIS.COMPLETED -EQ $FALSE)
                If($this.RewardsGiven -EQ $false) { # HAS THE REWARDSGIVEN FLAG NOT YET BEEN SET?
                    Foreach($A in $this.Rewards) { # LOOP THROUGH ALL THE ELEMENTS IN THE REWARDS CONTAINER
                        If($A.Given -EQ $false) { # HAS THIS ELEMENT'S GIVEN FLAG NOT YET BEEN SET?
                            $A.Give() # NO - EXECUTE THE ELEMENT'S GIVE METHOD (SETS THIS ELEMENT'S GIVEN FLAG)
                        }
                    }

                    $this.RewardsGiven = $true # SET THE REWARDSGIVEN FLAG
                    $this.Active       = $false # UNSET THE ACTIVE FLAG
                } # IF($THIS.REWARDSGIVEN -EQ $FALSE)
            } # IF($THIS.COMPLETED -EQ $FALSE)
        } # IF($THIS.ACTIVE -EQ $TRUE)
    } # END UPDATE METHOD DEFINITION
}

###############################################################################
#
# LET'S TALK ABOUT SOME PROPERTIES OF THE QUEST MANAGER.
#
# IT'S POSSIBLE THAT THE QUEST MANAGER DOESN'T HAVE ANY TRACKED QUESTS EVEN
# THOUGH THE QUESTLINES LIST HAS QUESTLINE INSTANCES IN IT.
#
###############################################################################
Class QuestManager {
    [Int]$TrackedQuestlineIndex
    [List[Questline]]$Questlines

    QuestManager() {
        $this.TrackedQuestlineIndex = 0
        $this.Questlines            = [List[Questline]]::new()
    }

    [Questline]GetTrackedQuest() {
        Return $this.Questlines[$this.TrackedQuestlineIndex]
    }

    [Void]Update() {
        Foreach($Q in $this.Questlines) {
            If($Q.Completed -EQ $false) {
                $Q.Update()
            }
        }
    }
}

Class QAHasItem : QuestStep {
    [String]$TargetItem

    QAHasItem() : base() {
        $this.TargetItem = ''
    }

    QAHasItem(
        [String]$TargetItem
    ) : base() {
        $this.TargetItem = $TargetItem
    }

    [Void]Update() {
        $this.Completed = $true
    }
}

Class QAQuestCompleted : QuestStep {
    [Quest]$TargetQuest

    QAQuestCompleted() : base() {
        $this.TargetQuest = $null
    }

    QAQuestCompleted(
        [Quest]$TargetQuest
    ) : base() {
        $this.TargetQuest = $TargetQuest
    }

    [Void]Update() {
        $this.Completed = $true
    }
}

Class QAPlayerHasGold : QuestStep {
    [Int]$GoldTarget

    QAPlayerHasGold() : base() {
        $this.GoldTarget = 0
    }

    QAPlayerHasGold(
        [Int]$GoldTarget
    ) : base() {
        $this.GoldTarget = $GoldTarget
    }

    [Void]Update() {
        $this.Completed = $true
    }
}

[Questline]$SampleQuestline2 = [Questline]::new(
    @(
        [NonlinearQuest]@{
            Steps = @(
                [QAHasItem]::new(),
                [QAPlayerHasGold]::new(),
                [QAQuestCompleted]::new(),
                [QuestStep]::new(),
                [QuestStep]::new()
            )
            Rewards = @(
                [QuestReward]::new(),
                [QuestReward]::new(),
                [QuestReward]::new()
            )
        },
        [LinearQuest]@{
            Steps = @(
                [QAHasItem]::new(),
                [QAPlayerHasGold]::new(),
                [QAQuestCompleted]::new(),
                [QuestStep]::new(),
                [QuestStep]::new(),
                [QuestStep]::new(),
                [QuestStep]::new(),
                [QuestStep]::new(),
                [QuestStep]::new(),
                [QuestStep]::new(),
                [QuestStep]::new()
            )
            Rewards = @(
                [QuestReward]::new(),
                [QuestReward]::new(),
                [QuestReward]::new()
            )
        }
    ),
    @(
        [QuestReward]::new(),
        [QuestReward]::new(),
        [QuestReward]::new(),
        [QuestReward]::new(),
        [QuestReward]::new()
    ),
    $true
)

[QuestManager]$TheQuestManager = [QuestManager]::new()
$TheQuestManager.Questlines.Add($SampleQuestline2) | Out-Null

