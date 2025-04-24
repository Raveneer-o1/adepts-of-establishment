# Adepts of Establishment 

[![GPLv3 License](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://opensource.org/licenses/)
[![Godot Engine](https://img.shields.io/badge/Godot-4.2%2B-%23478cbf)](https://godotengine.org)
[![Project Status](https://img.shields.io/badge/Status-Active%20Maintenance-yellowgreen)](https://github.com/Raveneer-o1/adepts-of-establishment)

**🚧 Project Status Notice (Updated: 02-03-2025)**
The Adepts of Establishment project is entering a maintenance phase while I focus on personal obligations. While active development is paused, **the project remains open**: I will be reviewing PRs, discussing issues etc.


## 🏰 Project Overview
**A free open-source spiritual successor to Disciples II**
*Turn-based strategy with evolution based progression in a dark fantasy world*

### If you're unfamiliar with the Disciples series:
Disciples is a dark fantasy strategy series blending turn-based empire-building, tactical combat, and rich RPG storytelling. The series initially drew comparisons to Heroes of Might & Magic but carved its niche through grim aesthetics and unit evolution system. These games combine strategic city management, hero development, and JRPG-like battles where unit positioning and evolution shape victory. The series is famed for its grim art style (by Patrick Lambert), and a "no-movement" combat system that emphasizes pre-planning over real-time tactics.

**Adepts of Establishment** carries this legacy forward with an open-source approach. We aim to create a game made by fans for fans.

<details>
  <summary>Unit trees</summary>

  ```mermaid
  graph TD
    subgraph Empire
        Squire["Squire"] --> Knight["Knight"]
        Knight --> Knight_Master["Knight Master"]
        Knight_Master --> Angel_Knight["Angel Knight"]
        Knight --> Horseman["Horseman"]
        Horseman --> Royal_Cavalier["Royal Cavalier"]
        Royal_Cavalier --> Paladin["Paladin"]
        
        Squire --> Witch_Hunter["Witch hunter"]
        Witch_Hunter --> Inquisitor["Inquisitor"]
        Inquisitor --> Grand_Inquisitor["Grand Inquisitor"]
        Witch_Hunter --> Samurai["Samurai"]
        Samurai --> Blade_Saint["Blade Saint"]
        
        Apprentice["Apprentice"] --> Elementalist["Elementalist"]
        Elementalist --> Ritualist["Ritualist"]
        Apprentice --> Mage["Mage"]
        Mage --> Wizard["Wizard"]
        Wizard --> White_Mage["White Mage"]
        White_Mage --> Keeper_of_Knowledge["Keeper of Knowledge"]
        White_Mage --> Arcanist["Arcanist"]
        
        Archer["Archer"] --> Marksman["Marksman"]
        Marksman --> Scout["Scout"]
        Scout --> Imperial_Ranger["Imperial Ranger"]
        Marksman --> Assassin["Assassin"]
        
        Acolyte["Acolyte"] --> Cleric["Cleric"]
        Cleric --> Matriarch["Matriarch"]
        Matriarch --> Prophetess["Prophetess"]
        Acolyte --> Priest["Priest"]
        Priest --> Imperial_priest["Imperial priest"]
        Imperial_priest --> Hierophant["Hierophant"]
    end
    subgraph Undead
        Warrior["Warrior"] --> Zombie["Zombie"]
        Zombie --> Phantom_warrior["Phantom warrior"]
        Zombie --> Skeleton["Skeleton"]
        Skeleton --> Skeleton_warrior["Skeleton warrior"]
        Skeleton_warrior --> Skeleton_champion["Skeleton champion"]
        Warrior --> Templar["Templar"]
        Templar --> Fallen_inquisitor["Fallen inquisitor"]
        Fallen_inquisitor --> Dark_lord["Dark lord"]

        Death_Acolyte["Death Acolyte"] --> Necromancer["Necromancer"]
        Necromancer --> Vampire["Vampire"]
        Vampire --> Elder_vampire["Elder vampire"]
        Elder_vampire --> Vampire_Lord["Vampire Lord"]
        Elder_vampire --> Blood_spawn["Blood spawn"]
        Necromancer --> Lich["Lich"]
        Lich --> Archlich["Archlich"]
        Death_Acolyte --> Dark_Mage["Dark Mage"]
        Dark_Mage --> Wraith["Wraith"]
        Wraith --> Herald_of_Death["Herald of Death"]
        
        Ghost["Ghost"] --> Specter["Specter"]
        Specter --> Will_o_Wisp["Will-o’-Wisp"]
        Will_o_Wisp --> The_eternal["The eternal"]
        Specter --> Shadow["Shadow"]
        Shadow --> Vision_of_Darkness["Vision of Darkness"]
        Shadow --> placeholder[style=invis]
        
        Wyvern["Wyvern"] --> Doomdrake["Doomdrake"]
        Doomdrake --> Gluttonous_Serpent["Gluttonous Serpent"]
        Gluttonous_Serpent --> The_Devourer["The Devourer"]
        Doomdrake --> Dreadwyrm["Dreadwyrm"]
        Dreadwyrm --> Undying_Nighthunter["Undying Nighthunter"]
        Undying_Nighthunter --> Dracolich["Dracolich"]
    end
  ```

  [Unit trees (old)](UnitStatsManager/unit%20trees.svg)
  
</details>

## 🛠️ Getting Started
**Requirements**: Godot Engine 4.3

```bash
git clone https://github.com/Raveneer-o1/adepts-of-establishment/adepts-of-establishment.git
```

## 🤝 How to Contribute
I encourage any contributions to the project, whether you're a programmer, artist, or just someone passionate about strategy games. Contributions can range from improving the codebase, adding assets, or suggesting new gameplay features (see below).

The codebase is thoroughly commented using Godot's built-in documentation format to ensure clarity and ease of understanding. However, if you find any part of the code unclear or difficult to follow, feel free to open an issue. We’ll discuss and work together to improve it.

All help welcome! No contribution too small:
### **Code** 
- (GDScript): Core gameplay, UI systems, AI
### **Art**:
- **UI**. The game doesn't have good interface right now. This is the weakest part of the project.
- Pixel art units (64x64), environment tilesets.
*Currently the game is implemented with 32x32 pixel art sprites.*
### **Game Design**:
- Balance factions
- Lore text is ok, however I do have my own vision on this world so it's best to leave this kind of changes to different forks
### **Testing**:
- Bug reports, compatibility checks


## 📜 License
This project is licensed under the [GNU General Public License v3 (GPL-3.0)](https://www.gnu.org/licenses/gpl-3.0.html). By contributing to the project, you agree to license your contributions under the same license.

## ✨ Acknowledgments
- Inspired by **Disciples II** (2002, Strategy First)
- Built with [Godot Engine](https://godotengine.org)
