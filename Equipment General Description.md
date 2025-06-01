# Equipment General Description

Each piece of equipment has the following properties:

    Name
    Description
    Purchase Price
        How much the item can be purchased for from shops.
    Sell Price
        How much the item can be sold for to shops.
    Target Stats
        The stats that this equipment augments when equipped, and by how much. It can be more than one, but at least one is required.
    Required Stats
        The stats and their values required so that the player can wear this equipment. It can be more than one, but at least one is required.

Considering the Player, it will have the following Equipment Slots augmented to it:

    Weapon
        The current weapon. There are a few kinds that can be equipped, each with their own specific effects.
    Helmet
        Worn on the head
    Armor
        Work on the chest
    Pauldron
        Work on the shoulders. Left and Right.
    Gauntlets
        Worn on the hands/arms. Left and Right.
    Greaves
        Worn on the legs. Left and Right.
    Boots
        Worn on the feet. Left and Right.
    Jewelry A
        Two per character. Informally is either a necklace, ring, or earrings.
    Jewelry B
        Two per character. Informally is either a neckalce, ring, or earrings.
    Cape
        One per character.

Enemy entities don't have equipment. They only have techniques and base stats.

This, I feel, changes some core concepts about the battle mechanics.

# Player Creation

Another change that I want to make to the player is to include gender, and also add some "profile images" in the same vein as the scene images. It's not yet clear what dimensions I can get away with on this while still maintaining some form of legibility.

What perks are there from choosing genders?

Males are generally lower in certain stats concerning intelligence and wisdom. They generally excel at strength and defense, and can use skills in that vein. Females are better at intelligence and wisdom and speed, but generally aren't high in strength and defense.

## Creation

When creating a new player, they all start off with the same base stats. Selecting a gender adds permanent random buff value to specific stats. The range of this randomness could be between 1 and 7. Players can re-roll to see if they get better stats; who cares. It's likely that re-rolling isn't going to yeild all the highest buffs.

The whole process of creating a new player would be as follows:

* Enter the player name (limited to 8 characters)
* Choose the player's gender (male or female)
* Allocate initial bonus points to whichever stats the player wants (accounts for gender bonuses)
* Choose the player's image (set changes based on gender selection)
* Choose the player's elemental affinity

This process implies a sub-state machine. The states can be defined as follows:

* PlayerSetupNameEntry
* PlayerSetupGenderSelection
* PlayerSetupPointAllocate
* PlayerSetupAffinitySelect
* PlayerSetupProfileSelect
* PlayerSetupConfirmation

Let's try to sketch something out here:

*-Name---------*        *-Gender---*    *-Profile--------------*
| Player Name  |        | > ♂  > ♀ |    |                      |
*--------------*        *----------*    |                      |
                                        |                      |
*-Bonus Points-------*  *-Affinity---*  |                      |
|  Points Left: 10   |  |  > A Fire  |  | <                  > |
|                    |  |  > A Water |  |                      |
|    ATK: < 999 >    |  |  > A Earth |  |                      |
|    DEF: < 999 >    |  |  > A Wind  |  |                      |
|    MAT: < 999 >    |  |  > A Light |  |                      |
|    MDF: < 999 >    |  |  > A Dark  |  |                      |
|    SPD: < 999 >    |  |  > A Ice   |  *----------------------*
|    ACC: < 999 >    |  *------------*
|    LCK: < 999 >    |
*--------------------*

------------------------------------------------

Dialog

*-----------------------------------------------------------------------------*
|
|      *-Confirm-------------------------------------*
|      |                                             |
|      | Name: NNNNNNNN     *-Profile--------------* |
|      |                    |                      | |
|      | Gender: G          |                      | |
|      |                    |                      | |
|      | Affinity: A        |                      | |
|      |                    |                      | |
|      | Stats              |                      | |
|      |                    |                      | |
|      |   ATK: 999         |                      | |
|      |   DEF: 999         |                      | |
|      |   MAT: 999         |                      | |
|      |   MDF: 999         *----------------------* |
|      |   SPD: 999                                  |
|      |   ACC: 999                                  |
|      |   LCK: 999                                  |
|      |                       Press Enter or Escape |
|      *---------------------------------------------*
|
|
|

9x20

I've done some testing with AI Art generators (Perchance) to make some profile images and it seems like 9x20 would be the better way to go. I may also break stride here and use Sixel instead of blocked images? This could cause some problems with me, but I need to think about some things in this regard. I'll stick with these for the time being while I generate the Player Creation screen.

The flow here can be derived from Burnt Latte as it contains a sub-state machine that dictates the flow of multi-window dialogs. One thing it does that I want to maintain here is conditionally show the windows as the state moves back and forth. That portion is key. The player should be able to go backward through the states regardless of where they are currently. The forward flow is as defined above in the original definition of the sub-state machine. The reverse flow is modeled off it.

## Behavior Definitions

### Player Setup Name Entry
The Name Entry window allows the player to input a player name. It's the first of the windows that's visible. There's a character limit of 8. This is enforced in much the same way as the Command Window in the GPS. If the player attempts to type a ninth character, nothing happens (this differs from the Command Window where it automatically invokes the Command Parser). If the player presses the Enter key, the state progresses to the Gender Selection state. If the player returns to this state from a forward state, the on-screen text and buffer for the name are reset and the cursor is replaced at the start of the field.

### Player Setup Gender Selection
The Gender Selection window allows the player to select a gender for their character. It's the second window that becomes visible to the player, and only becomes so when the player transitions to this state from the Name Entry state. The player can revert back to the Name Entry state by pressing the Escape key, which will cause this window to disappear from view. While in this state, the Unicode symbols for male and female are shown and a fixed-position chevron is used in much the same way it's used virtually everywhere else it's used at in Eldoria. If the player presses the Enter key, the chevron position will indicate the player's current selection, and the state progresses to the Point Allocate state. If the player returns to this state from a forward state, the previous selection will be wiped and will wait for he user to select a value again before moving to the next state.

### Player Setup Point Allocate
The Point Allocate window allows the player to allocate a handful of bonus points to specific stats for their character. This window works very much the same way that the color selector does in Burnt Latte (reference this code for more details). When this window is created, it considers the selection made in the Gender Selection state. The stats which benefit from the previous selection are highlighted in yellow (this doesn't include the numbers, just the stat name in the left column). The player can cycle through the stat values to augment by using the up and down arrow keys. The currently selected stat will exhibit several visual cues. First, it will have the left and right chevrons straddling it. Second, the number itself will blink pink. Moving the focus to a different stat will clear this for the previous one and activate it for the next target. The cycling will wrap; if the player is at the top-most position and presses the up arrow key, they'll be focused on the bottom-most stat, and vice-versa. The player can adjust the augment appreciation/depreciation with the left and right arrow keys. The right arrow key can be used until the total number of bonus points has been exhausted regardless of the stat that is currently selected. The left arrow key can only be used if the currently selected stat has bonus points assigned to it. If it does, those bonus points are subtracted by one until there are no longer any bonus points allocated to the stat. If the left or right arrow keys are pressed, the respective chevron highlights with an orange color until the key is released. If the player presses the Enter key, regardless if the available Bonus Points have been completely allocated, the state progresses to the Affinity Select state. If the player returns to this state from a forward state, the cursor position is reset to the top and the bonus points _are not_ reset.

### Player Setup Affinity Select
The Affinity Select window allows the player to select an Affinity they wish to associate their character with. The letter A in the display is a placeholder for the Unicode character that corresponds with the Affinity in the LUT. This is simply a vertical chevron listing, much the same in a lot of other places in Eldoria. The player can control the chevron with the up and down arrow keys. The cycling will wrap; if the player is at the top-most position and presses the up arrow key, they'll be focused on the bottom-most item. The currently targeted item will blink. If the player presses the Escape key, they'll be reverted to the Setup Point state. If the player presses the Enter key, the state progresses to the Profile Select state. If the player returns to this state from a forward state, the chevron restores to the position the player pressed Enter at.

### Player Setup Profile Select
The Profile Select window allows the player to cycle through some pre-made profile images to use as a vanity. The available ones are restricted by the gender the player chose back in the Gender Selection window. There are only a small number of these as these aren't really meant to be the focus of the exercise. When the window is active, two chevrons will appear on the left and right side of the window. The player can cycle through the filtered available images by pressing either the left or right arrow keys. When either of these keys are pressed, the corresponding chevron with have a bold color applied to it. When the corresponding key is released, the chevon will return to its original color. If the player presses the Enter key, the state progresses to the Profile Confirmation state. If the player returns to this state from a forward state, the Profile Select window becomes active again at the image where they left off.

### Player Setup Confirmation
