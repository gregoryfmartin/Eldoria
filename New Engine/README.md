Welcome to the Eldoria game repository! Please keep in mind that this project is currently under active development and is not in a finished state. You can download and run the game program on your own computer, but be aware that none of the scripts are signed and it's currently not in a ready-to-use state. That said, if you do decide to download and use it, feedback is always welcome!

Please read the wiki for more information.

# Prerequisites

## Operating System

* Windows 10 (AMD64/ARM64) or greater
* Windows Server 2019 or greater
* MacOS (latest version)
* Linux

## PowerShell

* PowerShell Core 7.3.0 or greater

## Terminal Emulators

### Windows

* Windows Terminal 1.21.x or greater

### MacOS

* iTerm2 (latest version)

### Linux

* Alacritty
* Kitty
* GNOME Terminal

## Caveats

### MacOS

* Your Mac needs to have the latest version of the .NET Framework installed. A complete guide to installing it can be found here: https://learn.microsoft.com/en-us/dotnet/core/install/macos. For Mac testing, .NET has been installed via brew.
* Your Mac needs to have the latest version of PowerShell installed. A complete guide to installing it can be found here: https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-macos?view=powershell-7.5. For Mac testing, PowerShell has been installed manually by downloading the binary from the official GitHub repository's Releases.
* iTerm2 doesn't support DEC Blink SGRs, so text that blinks as a consequence of this sequence will not work. This is not a detriment to the game play experience. Currently, no workaround has been devised.

### Linux

* Your Linux distribution needs to support the latest version of the .NET Framework. A complete guide to installing the .NET Framework on Linux is found here: https://learn.microsoft.com/en-us/dotnet/core/install/linux. Eldoria has been tested on the __dotnet-8*__ and __dotnet-9*__ packages on the following distributions:

  * Red Hat Enterprise Linux 8.x or greater
  * Oracle Enterprise Linux 8.x or greater
  * Rocky Linux 8.x or greater
  * Alma Linux 8.x or greater

* Your Linux distribution needs to support PowerShell Core 7.3.0 or greater. A complete guide to installing PowerShell on Linux is found here: https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-linux?view=powershell-7.5. Eldoria has been tested against PowerShell Core 7.3.0 or greater on the aforementioned Linux distributions.
* Alacritty and Kitty don't support DEC Blink SGRs, so text that blinks as a consequence of this sequence will not work. This is not a detriment to the game play experience. Currently, no workaround has been devised.

# Setup

Eldoria has migrated to a PowerShell Module layout. This has changed how the game is setup/invoked. When the game is complete, it'll hopefully be uploaded to PSGallery barring content restrictions. Until then, you can perform the following steps to download/bootstrap/run the game:

* Download this repository in its entirety or clone the master branch into a local directory on your computer.
* Open your terminal emulator, start PowerShell if it's not your default shell, and navigate to the directory where the repository is located at.
* Ensure that your terminal window is AT LEAST 90 columns by 40 rows in size.
* Import the module: `Import-Module .\Eldoria.psm1 -Force`. This will bootstrap the game (could take a minute or two).
* Once the bootstrap is complete, you'll be told that you can start the game by running the cmdlet `Start-Eldoria`. Run this to start the game.

# Bootstrapping Eldoria

Running `Import-Module .\Eldoria.psm1 -Force` will start the game bootstrapping process.

<img width="1210" height="495" alt="image" src="https://github.com/user-attachments/assets/1bf9bf78-ad8e-4295-aa4b-95229e236b18" />

This process could take some time since there's quite a bit of code to process. Once the bootstrap process is complete, you'll be prompted that you can start the game using the `Start-Eldoria` cmdlet:

<img width="479" height="92" alt="image" src="https://github.com/user-attachments/assets/a8b6ace7-8c4f-4fb4-885c-1ffc272278b4" />

# Title Screen

Eldoria has a nice little title sequence and animation:

![Eldoria Title Screen - Made with Clipchamp](https://github.com/user-attachments/assets/e6e65d19-a5fb-4916-8d1e-24be9b984356)

# Player Setup Screen

Eldoria allows you to customize your player before starting to play.

<img width="761" height="373" alt="image" src="https://github.com/user-attachments/assets/93fa867c-6372-4273-8d75-a0ea94fec8e2" />

The following customizations are available:

* Name - Type in the name of your player.
* Gender - Select the gender of your player. This has some influence over stat bonuses and what kinds of profile images you can select.
* Bonus Points - Allocate a fixed number of bonus points for various stats for the player. You have a maximum of 10 bonus points to freely allocate. If you don't like your base stats, you can re-roll using the `R` key.
* Affinity - This is the elemental affinity you want for your character. This has an influence over your use of magic. Magic use that aligns with the affinity receives a slight bonus, whereas magic use of an opposing or neutral affinity either receives no or a negative bonus.
* Profile Image - A profile image to use for your player.

# Navigating the World Map

The map can be navigated using the command "move" followed by a cardinal direction: north, south, east, or west.

<img width="807" height="601" alt="image" src="https://github.com/user-attachments/assets/ee1bec83-349e-4d49-b256-0cad743a7e2d" />

The movement commands can be abbreviated. The word "move" can be shortened to simply "m", and each of the cardinal directions can be abbreviated to "n", "s", "e", and "w" respectively:

<img width="804" height="597" alt="image" src="https://github.com/user-attachments/assets/90960fd4-859d-4737-bb6f-fff34e57f1a8" />

If a door, or some other kind of entrance, is on a tile, you can enter or exit it with either the "enter" or "exit" keywords (abbr. "en" or "ex" respectively):

<img width="806" height="596" alt="image" src="https://github.com/user-attachments/assets/40a59221-566a-4ca9-a38a-46d032b0aafa" />

<img width="802" height="594" alt="image" src="https://github.com/user-attachments/assets/ec1bd9e9-33ed-4c97-9a49-3126593ab104" />

# Interacting with Items on Tiles

Items on a tile can be determined using the "look" keyword (abbr. "l"):

<img width="803" height="596" alt="image" src="https://github.com/user-attachments/assets/6f074013-8c59-4045-97fc-9742c6fdd97e" />

Items on a tile can be examined for further details using the "examine" keyword (abbr. "exa"):

<img width="804" height="602" alt="image" src="https://github.com/user-attachments/assets/a1b698ea-2992-4980-9ba5-75c6cfb5e960" />

Certain items can be picked up and placed into the Player's inventory using either the "take" or "get" keywords (abbr "t" or "g" respectively):

<img width="803" height="597" alt="image" src="https://github.com/user-attachments/assets/931b5e77-c624-4ef4-ae79-406d0bf2bbf7" />

Items from the Player's inventory can be used on items in the current tile. For example, you can tie a Rope from your inventory to a Tree using the "use" keyword (abbr. "u") followed by "rope" and then "tree". In this example, the player doesn't have a rope in their inventory, so the game informs them:

<img width="803" height="599" alt="image" src="https://github.com/user-attachments/assets/e86cbb1e-0b4b-4bce-9dfc-a121ce3ae11b" />

# Player's Inventory

The Player's inventory can be accessed from the Navigation Screen using the "inventory" keyword (abbr. "i"):

<img width="803" height="600" alt="image" src="https://github.com/user-attachments/assets/e45e54f3-9a7e-459f-8abf-9bb496070858" />

The Inventory Screen works very much like a book. Each page of the inventory contains at most 10 items. If there are more than 10 items, pages are created to the right of the first one (indicated by the yellow chevron in the top-right corner). Each item has a description which is dynamically updated in the bottom portion of the window.

<img width="807" height="486" alt="image" src="https://github.com/user-attachments/assets/9bc68c9f-5dea-4d62-8c5b-ac34937ccee9" />

Subsequent pages can be accessed by turning right (D) or turning left (A):

<img width="806" height="483" alt="image" src="https://github.com/user-attachments/assets/6fc1fc51-2d51-408c-8807-b1cbc7657ac7" />

Items that can be used on the Player themselves offer more specific information regarding their effects on stats:

<img width="800" height="478" alt="image" src="https://github.com/user-attachments/assets/a773dafb-c8cb-4544-9378-6382801b9d70" />

Item's effects are randomized:

<img width="798" height="476" alt="image" src="https://github.com/user-attachments/assets/6660b6e9-f008-4ed7-9be0-ba75451531a0" />

When the Player issues a "use" command from the Navigation Screen, the very first instance of a matching item is used. Unsafe items can be dropped from the Player's inventory by pressing the S key. A beep will indicate a successful drop. Be aware that some items can't be dropped (these are called Key Items).

<img width="799" height="474" alt="image" src="https://github.com/user-attachments/assets/1d8c9f8f-8830-4ed1-b04c-2d387149dff4" />

The Inventory Screen can be exited by pressing the Escape key.

# Player Status/Action Equip Screen

The Player's status and inventory technique selection screen is bundled into one. It can be accessed from the Navigation Screen by using the keyword "status" (abbreviation. "sta"):

<img width="797" height="599" alt="image" src="https://github.com/user-attachments/assets/c0cba08a-6003-4cc0-b567-ef50e5c737e9" />

<img width="805" height="388" alt="image" src="https://github.com/user-attachments/assets/211fd4a0-2919-4f27-88de-79bc5703b3ce" />

The box in the bottom-left allows you to move the chevron up/down to select a technique to replace. Position the chevron using the up/down arrow keys and press Enter to access the Battle Action Inventory:

<img width="806" height="385" alt="image" src="https://github.com/user-attachments/assets/a3adae6f-2d24-41a5-81b8-8f8dc5b4e4e1" />

This inventory window behaves much the same as the Item Inventory window, just smaller and displaying information specific to the Battle Action you have selected. When you find a technique you want to use instead, press the Enter key again to equip the new action. If you don't wish to equip any actions, press the Escape key to return:

<img width="806" height="382" alt="image" src="https://github.com/user-attachments/assets/e369fa24-46de-4699-8a70-78c6a1c8a238" />

To exit the Player's Status Screen, press the Escape key until you're back at the Navigation Screen (at most 2 times).

# Battle

Battle encounters are random and can occur on tile moves. If you do encounter an enemy, a BATTLE COMMENCE message will appear and then the battle will start.

<img width="815" height="570" alt="image" src="https://github.com/user-attachments/assets/5cbfc2af-f785-42a8-bb15-fc28fb599f7b" />

Enemies are randomly assigned each time a battle starts. Battles are turn based. Whomever has the current turn will have their window highlighted yellow. When it's the enemy's turn, they will randomly select an attack and use it against the Player. When it's the Player's turn, you can use the up/down arrow keys to select an action and press Enter to use it:

<img width="815" height="574" alt="image" src="https://github.com/user-attachments/assets/094c870b-d750-46c4-885d-d58d81f72ca7" />

When the Player wins a battle, spoils are given and you're prompted to press the Enter key to return to the Navigation Screen. If the Player loses a battle, the game is over.
