const database = {
&"Dreadwyrm" : {
 &"scene_path": "res://Combat/Units/Derived units//Undead/u30_dreadwyrm.tscn", &"level": 3, &"large_unit": true, &"immunities": []
, &"description": "The Dreadwyrm is a terrifying draconic creature cloaked in necrotic energy. It soars above the battlefield, raining destruction with its corrupted breath. As a manifestation of death\'s will, it instills fear in all who face it, ensuring the enemy falters before its might.", &"faction": 2, &"unit_type": 1, &"attacks": [{
 &"damage_multiplier": 0.5, &"damage_override": false, &"is_heal": false, &"type": 1, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 35, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_archer_validity.tres", &"additional_targets": "res://Combat/Units/Parameters/Additional targets/entire_line.tres", &"damage_policy": "", &"applying_effects": {
  
} 
}]
, &"effects": [{
 &"effect_name": "Ward", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/ward.tscn", &"args": [3, 1]
 
}]
, &"base_damage": 90, &"max_hp": 600, &"armor": 20, &"evasion": 0.005, &"shielding_chance": 0.7 
},&"Vision of Darkness" : {
 &"scene_path": "res://Combat/Units/Derived units//Undead/u26_vision_of_darkness.tscn", &"level": 4, &"large_unit": false, &"immunities": [3]
, &"description": "The Vision of Darkness is an eldritch apparition that embodies the deepest fears of the living. It projects illusions to disorient and terrify enemies, making them vulnerable to other undead forces. With its commanding aura and mind-twisting abilities, the Vision of Darkness is both a psychological and magical powerhouse on the battlefield.", &"faction": 2, &"unit_type": 1, &"attacks": [{
 &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 0, &"accuracy": 0.685, &"targets_needed": 1, &"initiative": 25, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_archer_validity.tres", &"additional_targets": "res://Combat/Units/Parameters/Additional targets/Splash.tres", &"damage_policy": "", &"applying_effects": {
 "paralysis": [0.9, 1]
 
} 
}]
, &"effects": []
, &"base_damage": 25, &"max_hp": 150, &"armor": 0, &"evasion": 0.2, &"shielding_chance": 0.7 
},&"Undying Nighthunter" : {
 &"scene_path": "res://Combat/Units/Derived units//Undead/u32_undying_nighthunter.tscn", &"level": 4, &"large_unit": true, &"immunities": []
, &"description": "The Undying Nighthunter is a dragon that defies the limitations of mortality. Rising from death, it becomes a relentless predator of the night, hunting down its prey with precision and terror. Its ability to vanish into darkness make it a nightmare of living, and no enemy escapes its wrath.", &"faction": 2, &"unit_type": 1, &"attacks": [{
 &"damage_multiplier": 0.7, &"damage_override": false, &"is_heal": false, &"type": 1, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 35, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_archer_validity.tres", &"additional_targets": "res://Combat/Units/Parameters/Additional targets/entire_line.tres", &"damage_policy": "res://Combat/Units/Parameters/Policy/decay_policy.tres", &"applying_effects": {
 "only_to_type": [2, "weakness", [3, 35]
]
 
} 
}]
, &"effects": [{
 &"effect_name": "Ward", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/ward.tscn", &"args": [3, 2]
 
}]
, &"base_damage": 180, &"max_hp": 800, &"armor": 35, &"evasion": 0.005, &"shielding_chance": 0.7 
},&"Templar" : {
 &"scene_path": "res://Combat/Units/Derived units//Undead/u03_Templar.tscn", &"level": 2, &"large_unit": false, &"immunities": []
, &"description": "Templars are former knights who willingly embraced undeath to serve the Necropolis. Empowered by unholy energy, they strike down enemies with cursed blades that sap life from their foes. Their armor, imbued with necromantic runes, provides enhanced protection, making them formidable front-line warriors with a sinister aura.", &"faction": 2, &"unit_type": 0, &"attacks": [{
 &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 0, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 40, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_melee_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
  
} 
}]
, &"effects": [{
 &"effect_name": "Ward", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/ward.tscn", &"args": [1, 1]
 
}, {
 &"effect_name": "Twisted will", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/random_retaliation_on_debuff.tscn", &"args": [2, 0, 1.2]
 
}]
, &"base_damage": 45, &"max_hp": 150, &"armor": 10, &"evasion": 0.05, &"shielding_chance": 0.75 
},&"Wyvern" : {
 &"scene_path": "res://Combat/Units/Derived units//Undead/u27_wyvern.tscn", &"level": 1, &"large_unit": true, &"immunities": []
, &"description": "Wyverns are the earthbound cousins of dragons, stripped of the freedom of flight. Their bitterness over this difference drives them to seek power, often turning to the God of Death for strength and vengeance. While physically imposing, wyverns lack the majesty of true dragons, channeling their rage into ferocious attacks.", &"faction": 2, &"unit_type": 1, &"attacks": [{
 &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 1, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 35, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_archer_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
  
} 
}]
, &"effects": []
, &"base_damage": 50, &"max_hp": 300, &"armor": 0, &"evasion": 0.005, &"shielding_chance": 0.7 
},&"Herald of Death" : {
 &"scene_path": "res://Combat/Units/Derived units//Undead/u18_herald_of_death.tscn", &"level": 4, &"large_unit": false, &"immunities": [3]
, &"description": "The Heralds of Death are necromantic priests who serve as emissaries of the Necropolis\'s dark gods. They channel divine death magic to empower allies and wreak havoc on their enemies. With their unholy auras and devastating spells, they are both revered by their followers and feared by their foes.", &"faction": 2, &"unit_type": 2, &"attacks": [{
 &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 1, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 40, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_mage_validity.tres", &"additional_targets": "res://Combat/Units/Parameters/Additional targets/Splash.tres", &"damage_policy": "res://Combat/Units/Derived units/Undead/u18_herald_of_death.tscn::Resource_4fa37", &"applying_effects": {
 "weakness": [2, 30]
 
} 
}]
, &"effects": [{
 &"effect_name": "Ward", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/ward.tscn", &"args": [0, 2]
 
}]
, &"base_damage": 60, &"max_hp": 180, &"armor": 0, &"evasion": 0.05, &"shielding_chance": 0.7 
},&"Ghost" : {
 &"scene_path": "res://Combat/Units/Derived units//Undead/u21_ghost.tscn", &"level": 1, &"large_unit": false, &"immunities": [3]
, &"description": "Ghosts are the lingering spirits of the dead, cursed to wander the mortal realm. Though their spectral forms are fragile, they are immune to physical attacks, making them tricky opponents. Their chilling presence weakens the resolve of their enemies, while their attacks drain the vitality of the living leaving them paralyzed.", &"faction": 2, &"unit_type": 1, &"attacks": [{
 &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 2, &"accuracy": 0.65, &"targets_needed": 1, &"initiative": 25, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_archer_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
 "paralysis": [1.0, 1]
 
} 
}]
, &"effects": []
, &"base_damage": 0, &"max_hp": 70, &"armor": 0, &"evasion": 0.07, &"shielding_chance": 0.7 
},&"The Devourer" : {
 &"scene_path": "res://Combat/Units/Derived units//Undead/u31_the_devourer.tscn", &"level": 4, &"large_unit": true, &"immunities": []
, &"description": "The Devourer is a monstrous snake-like creature, bloated with the power of countless consumed souls. Its sheer size and overwhelming strength make it an unstoppable force, crushing enemies under its bulk. Its feeding frenzy is unending, spreading despair and destruction across the battlefield.", &"faction": 2, &"unit_type": 0, &"attacks": [{
 &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 0, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 40, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_melee_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
  
} 
}]
, &"effects": [{
 &"effect_name": "Devourer", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/devourer.tscn", &"args": 200 
}, {
 &"effect_name": "Ward", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/ward.tscn", &"args": [3, 1]
 
}, {
 &"effect_name": "Agility", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/agility.tscn", &"args": [3, 1.3]
 
}]
, &"base_damage": 240, &"max_hp": 800, &"armor": 35, &"evasion": 0.1, &"shielding_chance": 0.7 
},&"Skeleton Hero" : {
 &"scene_path": "res://Combat/Units/Derived units//Undead/u09_skeleton_hero.tscn", &"level": 5, &"large_unit": false, &"immunities": []
, &"description": "Skeleton Heroes are the pinnacle of necromantic reanimation, resurrected from the remains of legendary champions of old. Their undying forms retain the combat expertise they mastered in life, now enhanced by unholy power. Leading the armies of the Necropolis with a mix of tactical brilliance and raw strength, they are a force to be reckoned with, feared by both the living and the dead.", &"faction": 2, &"unit_type": 0, &"attacks": [{
 &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 0, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 40, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_melee_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
  
} 
}]
, &"effects": [{
 &"effect_name": "Crafted body", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/crafted_body.tscn", &"args": {
 &"armor": 20, &"base_damage": 30, &"evasion": 0.02, &"max_HP": 70 
} 
}, {
 &"effect_name": "Grave caress", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/vampirism.tscn", &"args": [20.0, false]
 
}, {
 &"effect_name": "Regeneration", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/on_turn_self_heal.tscn", &"args": 30 
}, {
 &"effect_name": "Crypt spirit", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/on_death_summon.tscn", &"args": ["res://Combat/Units/Derived units/Undead/u05_skeleton.tscn", {
 "reanimation": {
 &"armor": 5, &"base_damage": 10, &"evasion": 0.005, &"max_HP": 15 
} 
}]
 
}]
, &"base_damage": 100, &"max_hp": 350, &"armor": 50, &"evasion": 0.05, &"shielding_chance": 0.3 
},&"The Eternal" : {
 &"scene_path": "res://Combat/Units/Derived units//Undead/u25_the_eternal.tscn", &"level": 4, &"large_unit": false, &"immunities": [1]
, &"description": "The Eternal is a spirit bound by an ancient, unbreakable curse, its presence a harbinger of inevitable doom. This spectral entity wields overwhelming power, draining life from entire groups of enemies with its devastating attacks. Its unyielding persistence in battle makes it a terrifying force, embodying the unending grasp of death.", &"faction": 2, &"unit_type": 3, &"attacks": [{
 &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 1, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 35, &"evadable": true, &"tags": [&"shot"]
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_archer_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
 "burn": [1, 25]
, "confused": [3, 0.65]
 
} 
}]
, &"effects": []
, &"base_damage": 40, &"max_hp": 180, &"armor": 0, &"evasion": 0.2, &"shielding_chance": 0.7 
},&"Dark Mage" : {
 &"scene_path": "res://Combat/Units/Derived units//Undead/u12_dark_mage.tscn", &"level": 2, &"large_unit": false, &"immunities": []
, &"description": "Dark Mages delve into the forbidden arts of destructive magic, harnessing shadow and decay to annihilate their enemies. Their spells spread fear and chaos, breaking the will of the living. While less adept at raising the dead, their offensive capabilities make them invaluable on the battlefield.", &"faction": 2, &"unit_type": 2, &"attacks": [{
 &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 0, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 40, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_mage_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
 "weakness": [1, 10]
 
} 
}]
, &"effects": []
, &"base_damage": 30, &"max_hp": 75, &"armor": 0, &"evasion": 0.05, &"shielding_chance": 0.7 
},&"Skeleton warrior" : {
 &"scene_path": "res://Combat/Units/Derived units//Undead/u07_skeleton_warrior.tscn", &"level": 4, &"large_unit": false, &"immunities": []
, &"description": "Elite undead warriors, crafted from the bones of legendary fighters. Their bodies are reinforced with necromantic magic, granting them unparalleled strength and durability. Clad in ancient, rune-inscribed armor, they lead lesser undead into battle with an imposing presence that inspires dread in their enemies.", &"faction": 2, &"unit_type": 0, &"attacks": [{
 &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 0, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 40, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_melee_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
  
} 
}]
, &"effects": [{
 &"effect_name": "Crafted body", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/crafted_body.tscn", &"args": {
 &"armor": 15, &"base_damage": 30, &"evasion": 0.015, &"max_HP": 50 
} 
}, {
 &"effect_name": "Regeneration", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/on_turn_self_heal.tscn", &"args": 25 
}, {
 &"effect_name": "Crypt spirit", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/on_death_summon.tscn", &"args": ["res://Combat/Units/Derived units/Undead/u05_skeleton.tscn", {
 "reanimation": {
 &"armor": 5, &"base_damage": 10, &"evasion": 0.005, &"max_HP": 15 
} 
}]
 
}]
, &"base_damage": 80, &"max_hp": 275, &"armor": 35, &"evasion": 0.05, &"shielding_chance": 0.0 
},&"Necromancer" : {
 &"scene_path": "res://Combat/Units/Derived units//Undead/u11_necromancer.tscn", &"level": 2, &"large_unit": false, &"immunities": []
, &"description": "Necromancers are skilled manipulators of life and death, capable of raising undead with their spells. They command dark energies to weaken foes and bolster allies. Despite their mortal vulnerability, their mastery of death makes them a cornerstone of the Necropolis\'s power.", &"faction": 2, &"unit_type": 2, &"attacks": [{
 &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 0, &"accuracy": 0.85, &"targets_needed": 1, &"initiative": 30, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/necromancer_validity.tres", &"additional_targets": "", &"damage_policy": "res://Combat/Units/Derived units/Undead/u11_necromancer.tscn::Resource_0m3ru", &"applying_effects": {
  
} 
}]
, &"effects": []
, &"base_damage": 30, &"max_hp": 75, &"armor": 0, &"evasion": 0.05, &"shielding_chance": 0.7 
},&"Dark Lord" : {
 &"scene_path": "res://Combat/Units/Derived units//Undead/u08_dark_lord.tscn", &"level": 4, &"large_unit": false, &"immunities": [1]
, &"description": "Dark Lords are powerful commanders of the Necropolis, imbued with overwhelming dark magic and martial prowess. Their mere presence unnerves the living, sapping their will to fight. Wielding cursed weapons and commanding legions of undead, they are both fearsome warriors and ruthless strategists, capable of turning the tide of any battle.", &"faction": 2, &"unit_type": 0, &"attacks": [{
 &"damage_multiplier": 0.65, &"damage_override": false, &"is_heal": false, &"type": 1, &"accuracy": 0.95, &"targets_needed": 2, &"initiative": 40, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_melee_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
 "silence": 1 
} 
}]
, &"effects": [{
 &"effect_name": "Twisted will", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/random_retaliation_on_debuff.tscn", &"args": [-1, 0, 1.3]
 
}, {
 &"effect_name": "Denial", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/negative_effect_negate.tscn", &"args": 3 
}]
, &"base_damage": 80, &"max_hp": 275, &"armor": 35, &"evasion": 0.05, &"shielding_chance": 0.7 
},&"Destined" : {
 &"scene_path": "res://Combat/Units/Derived units//Undead/u01_destined.tscn", &"level": 1, &"large_unit": false, &"immunities": []
, &"description": "The Destined are individuals who pledge their lives to the King of Necropolis even before death claims them. This devotion grants them a fragile connection to the forces of death, allowing them to manipulate minor necromantic powers. However, their frail, living bodies struggle to withstand the rigors of combat", &"faction": 2, &"unit_type": 0, &"attacks": [{
 &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 0, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 40, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_melee_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
  
} 
}]
, &"effects": []
, &"base_damage": 35, &"max_hp": 90, &"armor": 0, &"evasion": 0.04, &"shielding_chance": 0.7 
},&"Zombie" : {
 &"scene_path": "res://Combat/Units/Derived units//Undead/u02_Zombie.tscn", &"level": 2, &"large_unit": false, &"immunities": [3]
, &"description": "Zombies are the reanimated corpses of the recently deceased, brought back to life through dark magic. Slow and uncoordinated, they rely on their overwhelming resilience to survive attacks that would fell most living warriors. Though lacking in intelligence, their sheer persistence makes them a constant threat on the battlefield.", &"faction": 2, &"unit_type": 0, &"attacks": [{
 &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 0, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 30, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_melee_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
  
} 
}]
, &"effects": [{
 &"effect_name": "Regeneration", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/on_turn_self_heal.tscn", &"args": 10 
}]
, &"base_damage": 35, &"max_hp": 200, &"armor": 15, &"evasion": 0.025, &"shielding_chance": 0.8 
},&"Vampire" : {
 &"scene_path": "res://Combat/Units/Derived units//Undead/u13_vampire.tscn", &"level": 3, &"large_unit": false, &"immunities": []
, &"description": "Vampires are necromancers who dared to perform the blood ritual, a dark rite that grants immortality at a terrible cost. Empowered by the forbidden magic coursing through their veins, they possess unmatched agility and ferocity in combat. Their vampiric bite drains the lifeforce of their enemies, fueling their insatiable hunger while sustaining their undead existence.", &"faction": 2, &"unit_type": 2, &"attacks": [{
 &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 3, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 40, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_archer_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
  
} 
}]
, &"effects": [{
 &"effect_name": "Vampirism", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/vampirism.tscn", &"args": [0.4, true]
 
}, {
 &"effect_name": "Ward", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/ward.tscn", &"args": [3, 1]
 
}]
, &"base_damage": 40, &"max_hp": 150, &"armor": 0, &"evasion": 0.05, &"shielding_chance": 0.7 
},&"Specter" : {
 &"scene_path": "res://Combat/Units/Derived units//Undead/u22_specter.tscn", &"level": 2, &"large_unit": false, &"immunities": [3]
, &"description": "Specters are stronger and more malicious spirits, bound by dark magic to serve the Necropolis. Their ethereal nature allows them to phase through obstacles and evade most attacks, striking fear into the hearts of their foes. They emit a spectral wail that unnerves enemies and disrupts their defenses.", &"faction": 1, &"unit_type": 0, &"attacks": [{
 &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 2, &"accuracy": 0.75, &"targets_needed": 1, &"initiative": 25, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_archer_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
 "paralysis": [0.7, 1]
 
} 
}]
, &"effects": []
, &"base_damage": 10, &"max_hp": 100, &"armor": 0, &"evasion": 0.1, &"shielding_chance": 0.7 
},&"Fallen Inquisitor" : {
 &"scene_path": "res://Combat/Units/Derived units//Undead/u06_fallen_inquisitor.tscn", &"level": 3, &"large_unit": false, &"immunities": []
, &"description": "Once holy warriors, Fallen Inquisitors were corrupted by the Necropolis\'s dark power. Now they wield their former knowledge of divine magic against the living, combining brutal melee combat with devastating unholy spells. Their tragic fall from grace is reflected in their fierce hatred for their former brethren, making them relentless in battle.", &"faction": 2, &"unit_type": 0, &"attacks": [{
 &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 1, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 40, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_melee_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
 "silence": 0 
} 
}]
, &"effects": [{
 &"effect_name": "Ward", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/ward.tscn", &"args": [1, 1]
 
}, {
 &"effect_name": "Twisted will", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/random_retaliation_on_debuff.tscn", &"args": [4, 0, 1.25]
 
}, {
 &"effect_name": "Denial", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/negative_effect_negate.tscn", &"args": 1 
}]
, &"base_damage": 60, &"max_hp": 200, &"armor": 20, &"evasion": 0.05, &"shielding_chance": 0.7 
},&"Elder vampire" : {
 &"scene_path": "res://Combat/Units/Derived units//Undead/u16_elder_vampire.tscn", &"level": 4, &"large_unit": false, &"immunities": []
, &"description": "Elder Vampires are ancient beings whose bloodlust excel limits of a mortal mind. They possess extraordinary strength and command blood magic with terrifying precision. Their mere presence inspires awe and dread, as they dominate the battlefield with their unmatched prowess and cunning.", &"faction": 2, &"unit_type": 2, &"attacks": [{
 &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 3, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 40, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_mage_validity.tres", &"additional_targets": "res://Combat/Units/Parameters/Additional targets/Splash.tres", &"damage_policy": "res://Combat/Units/Derived units/Undead/u16_elder_vampire.tscn::Resource_5sbny", &"applying_effects": {
 "clumsiness": [0.05, 2]
 
} 
}]
, &"effects": [{
 &"effect_name": "Vampirism", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/vampirism.tscn", &"args": [0.6, true]
 
}, {
 &"effect_name": "Ward", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/ward.tscn", &"args": [3, 1]
 
}]
, &"base_damage": 60, &"max_hp": 220, &"armor": 0, &"evasion": 0.05, &"shielding_chance": 0.7 
},&"Gluttonous Serpent" : {
 &"scene_path": "res://Combat/Units/Derived units//Undead/u29_gluttonous_serpent.tscn", &"level": 3, &"large_unit": true, &"immunities": []
, &"description": "The Gluttonous Serpent is a grotesque creature that has abandoned all thought for insatiable hunger. With an elongated, serpentine body and jaws capable of consuming multiple foes, it leaves destruction in its wake. Though mindless, its appetite makes it an overwhelming force that overwhelms through sheer persistence.", &"faction": 2, &"unit_type": 0, &"attacks": [{
 &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 0, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 35, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_melee_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
  
} 
}]
, &"effects": [{
 &"effect_name": "Ward", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/ward.tscn", &"args": [3, 1]
 
}, {
 &"effect_name": "Devourer", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/devourer.tscn", &"args": 100 
}]
, &"base_damage": 120, &"max_hp": 600, &"armor": 20, &"evasion": 0.05, &"shielding_chance": 0.7 
},&"Archlich" : {
 &"scene_path": "res://Combat/Units/Derived units//Undead/u17_archlich.tscn", &"level": 4, &"large_unit": false, &"immunities": [3]
, &"description": "Archliches are the pinnacle of necromantic evolution, their phylacteries granting them near-immortality and inexhaustible power. They wield arcane forces capable of obliterating entire battalions or summoning legions of undead. Revered as leaders and feared as conquerors, Archliches are the true masterminds of the Necropolis.", &"faction": 2, &"unit_type": 2, &"attacks": [{
 &"damage_multiplier": 0.3, &"damage_override": false, &"is_heal": false, &"type": 1, &"accuracy": 0.95, &"targets_needed": 2, &"initiative": 30, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/necromancer_validity.tres", &"additional_targets": "", &"damage_policy": "res://Combat/Units/Derived units/Undead/u17_archlich.tscn::Resource_avfpn", &"applying_effects": {
 "death_curse": [-1, 10]
 
} 
}, {
 &"damage_multiplier": 0.2, &"damage_override": false, &"is_heal": false, &"type": 1, &"accuracy": 0.95, &"targets_needed": 2, &"initiative": 30, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/necromancer_validity.tres", &"additional_targets": "", &"damage_policy": "res://Combat/Units/Parameters/Policy/necromancer_policy.tres", &"applying_effects": {
 "death_curse": [-1, 10]
 
} 
}]
, &"effects": []
, &"base_damage": 60, &"max_hp": 150, &"armor": 0, &"evasion": 0.05, &"shielding_chance": 0.7 
},&"Dracolich" : {
 &"scene_path": "res://Combat/Units/Derived units//Undead/u33_Dracolich.tscn", &"level": 5, &"large_unit": true, &"immunities": [3]
, &"description": "The pinnacle of undead draconic evolution. The Dracolich is an intelligent lich-dragon whose very presence decays the living. It commands legions of the dead and wields a breath of pure entropy, making it the ultimate instrument of oblivion.", &"faction": 2, &"unit_type": 1, &"attacks": [{
 &"damage_multiplier": 0.8, &"damage_override": false, &"is_heal": false, &"type": 1, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 35, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_archer_validity.tres", &"additional_targets": "res://Combat/Units/Parameters/Additional targets/entire_line.tres", &"damage_policy": "res://Combat/Units/Parameters/Policy/decay_policy.tres", &"applying_effects": {
 "death_curse": [-1, 10]
, "only_to_type": [2, "weakness", [3, 35]
]
 
} 
}]
, &"effects": []
, &"base_damage": 200, &"max_hp": 1000, &"armor": 50, &"evasion": 0.01, &"shielding_chance": 0.7 
},&"Blood spawn" : {
 &"scene_path": "res://Combat/Units/Derived units//Undead/u19_blood_spawn.tscn", &"level": 5, &"large_unit": false, &"immunities": []
, &"description": "Blood Spawn are the monstrous remnants of vampires who succumbed to their insatiable bloodlust. Mutated beyond recognition, they embody pure rage and hunger, striking terror into the hearts of all who face them. Their brutal attacks and unrelenting ferocity make them devastating forces of destruction, but their mindless nature renders them dangerous to friend and foe alike.", &"faction": 2, &"unit_type": 0, &"attacks": [{
 &"damage_multiplier": 0.5, &"damage_override": false, &"is_heal": false, &"type": 0, &"accuracy": 0.95, &"targets_needed": 2, &"initiative": 40, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_melee_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
  
} 
}]
, &"effects": [{
 &"effect_name": "Vampirism", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/vampirism.tscn", &"args": [0.5, true]
 
}, {
 &"effect_name": "Fear aura", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/fear_aura.tscn", &"args": 0.05 
}, {
 &"effect_name": "Ward", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/ward.tscn", &"args": [3, 2]
 
}]
, &"base_damage": 100, &"max_hp": 350, &"armor": 50, &"evasion": 0.1, &"shielding_chance": 0.7 
},&"Wraith" : {
 &"scene_path": "res://Combat/Units/Derived units//Undead/u15_wraith.tscn", &"level": 3, &"large_unit": false, &"immunities": [3]
, &"description": "Wraiths are ethereal beings formed from the tormented souls of the dead. Their ghostly forms make them nearly invulnerable to physical attacks, allowing them to pass through the battlefield with ease. Wielding spectral claws, they sap the vitality of their victims while spreading despair among their enemies.", &"faction": 2, &"unit_type": 2, &"attacks": [{
 &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 1, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 40, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_mage_validity.tres", &"additional_targets": "res://Combat/Units/Parameters/Additional targets/Splash.tres", &"damage_policy": "res://Combat/Units/Derived units/Undead/u15_wraith.tscn::Resource_uj6co", &"applying_effects": {
 "weakness": [1, 10]
 
} 
}]
, &"effects": [{
 &"effect_name": "Ward", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/ward.tscn", &"args": [0, 1]
 
}]
, &"base_damage": 40, &"max_hp": 100, &"armor": 0, &"evasion": 0.05, &"shielding_chance": 0.7 
},&"Lich" : {
 &"scene_path": "res://Combat/Units/Derived units//Undead/u14_lich.tscn", &"level": 3, &"large_unit": false, &"immunities": [3]
, &"description": "Liches are necromancers who have transcended mortality by binding their souls to phylacteries. These skeletal sorcerers wield immense magical power, unleashing devastating curses and summoning hordes of undead with ease. Their cold intellect and timeless experience make them formidable adversaries and invaluable strategists.", &"faction": 2, &"unit_type": 2, &"attacks": [{
 &"damage_multiplier": 0.6, &"damage_override": false, &"is_heal": false, &"type": 1, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 30, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/necromancer_validity.tres", &"additional_targets": "", &"damage_policy": "res://Combat/Units/Derived units/Undead/u14_lich.tscn::Resource_4gd0u", &"applying_effects": {
 "death_curse": [-1, 7]
 
} 
}, {
 &"damage_multiplier": 0.4, &"damage_override": false, &"is_heal": false, &"type": 1, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 25, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/necromancer_validity.tres", &"additional_targets": "", &"damage_policy": "res://Combat/Units/Derived units/Undead/u14_lich.tscn::Resource_4gd0u", &"applying_effects": {
 "death_curse": [-1, 7]
 
} 
}]
, &"effects": []
, &"base_damage": 40, &"max_hp": 85, &"armor": 0, &"evasion": 0.05, &"shielding_chance": 0.7 
},&"Will-o’-Wisp" : {
 &"scene_path": "res://Combat/Units/Derived units//Undead/u23_will_o_wisp.tscn", &"level": 3, &"large_unit": false, &"immunities": [1]
, &"description": "Will-o’-Wisps are flickering lights that guide unsuspecting souls to their doom. These malicious spirits use their hypnotic glow to lure enemies into traps or isolate them from their allies. While not physically strong, their agility and ability to vanish into the shadows make them elusive and dangerous.", &"faction": 2, &"unit_type": 3, &"attacks": [{
 &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 1, &"accuracy": 0.9, &"targets_needed": 1, &"initiative": 30, &"evadable": true, &"tags": [&"shot"]
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_archer_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
 "burn": [1, 25]
, "confused": [2, 0.5]
 
} 
}]
, &"effects": []
, &"base_damage": 30, &"max_hp": 140, &"armor": 0, &"evasion": 0.15, &"shielding_chance": 0.7 
},&"Skeleton" : {
 &"scene_path": "res://Combat/Units/Derived units//Undead/u05_skeleton.tscn", &"level": 3, &"large_unit": false, &"immunities": [3]
, &"description": "Skeletons are the quintessential soldiers of the undead, reassembled from the bones of the dead. While they lack the sophistication of living warriors, their undying loyalty and endless stamina make them reliable infantry. Armed with a variety of weapons, they form the backbone of the Necropolis\'s armies, marching tirelessly to their master\'s commands.", &"faction": 2, &"unit_type": 0, &"attacks": [{
 &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 0, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 40, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_melee_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
  
} 
}]
, &"effects": [{
 &"effect_name": "Crafted body", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/crafted_body.tscn", &"args": {
 &"max_HP": 30, &"armor": 10, &"base_damage": 20, &"evasion": 0.01 
} 
}, {
 &"effect_name": "Regeneration", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/on_turn_self_heal.tscn", &"args": 20 
}]
, &"base_damage": 60, &"max_hp": 200, &"armor": 20, &"evasion": 0.05, &"shielding_chance": 0.0 
},&"Shadow" : {
 &"scene_path": "res://Combat/Units/Derived units//Undead/u24_shadow.tscn", &"level": 3, &"large_unit": false, &"immunities": [3]
, &"description": "Shadow\'s very essence a manifestation of fear and despair. They attack by engulfing their targets in a cold, suffocating void, sapping their strength and will. Difficult to detect and harder to fight, Shadows excel at ambushing their prey and disrupting enemy formations.", &"faction": 2, &"unit_type": 1, &"attacks": [{
 &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 0, &"accuracy": 0.65, &"targets_needed": 1, &"initiative": 25, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_archer_validity.tres", &"additional_targets": "res://Combat/Units/Parameters/Additional targets/Splash.tres", &"damage_policy": "", &"applying_effects": {
 "paralysis": [0.9, 2]
 
} 
}]
, &"effects": []
, &"base_damage": 15, &"max_hp": 11, &"armor": 0, &"evasion": 0.15, &"shielding_chance": 0.7 
},&"Vampire Lord" : {
 &"scene_path": "res://Combat/Units/Derived units//Undead/u20_vampire_lord.tscn", &"level": 5, &"large_unit": false, &"immunities": []
, &"description": "Vampire Lords are the supreme rulers of their kind, commanding legions of undead and wielding unparalleled mastery over blood magic. Their regal presence belies their monstrous strength and cunning intellect, making them both inspiring leaders and fearsome warriors. With centuries of experience and an insatiable hunger for power, Vampire Lords are the ultimate embodiment of the Necropolis\'s dark ambition.", &"faction": 2, &"unit_type": 2, &"attacks": [{
 &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 3, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 45, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_archer_validity.tres", &"additional_targets": "res://Combat/Units/Parameters/Additional targets/Splash.tres", &"damage_policy": "res://Combat/Units/Derived units/Undead/u20_vampire_lord.tscn::Resource_n62fs", &"applying_effects": {
 "clumsiness": [0.05, 2]
, "vulnerability": [3, 10]
 
} 
}]
, &"effects": [{
 &"effect_name": "Vampirism", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/vampirism.tscn", &"args": [0.65, true]
 
}, {
 &"effect_name": "Ward", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/ward.tscn", &"args": [3, 2]
 
}]
, &"base_damage": 75, &"max_hp": 285, &"armor": 0, &"evasion": 0.05, &"shielding_chance": 0.7 
},&"Phantom Warrior" : {
 &"scene_path": "res://Combat/Units/Derived units//Undead/u04_phantom_warrior.tscn", &"level": 3, &"large_unit": false, &"immunities": [3]
, &"description": "Phantom Warriors are spectral remnants of fallen soldiers, bound to the will of the Necropolis. They drift across the battlefield, their incorporeal forms allowing them to evade physical attacks. Armed with ghostly weapons, they deliver chilling strikes that sap the vitality of their foes, leaving them weakened and vulnerable.", &"faction": 2, &"unit_type": 0, &"attacks": [{
 &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 2, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 40, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/melee_with_self.tres", &"additional_targets": "", &"damage_policy": "res://Combat/Units/Parameters/Policy/phantom_warrior_policy.tres", &"applying_effects": {
  
} 
}]
, &"effects": [{
 &"effect_name": "Illusive", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/illusive.tscn", &"args": {
 &"evasion_buff": 0.03, &"other_stat_buff": "Attack", &"other_stat_buff_strength": 10, &"other_stat_buff_multiplier": 1.0 
} 
}, {
 &"effect_name": "Phantom", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/Phantom.tscn", &"args": [0, 1]
 
}]
, &"base_damage": 45, &"max_hp": 180, &"armor": 10, &"evasion": 0.1, &"shielding_chance": 0.7 
},&"Doomdrake" : {
 &"scene_path": "res://Combat/Units/Derived units//Undead/u28_doomdrake.tscn", &"level": 2, &"large_unit": true, &"immunities": []
, &"description": "A wyvern that succumbs to the influence of the Necropolis transforms into a Doomdrake. These beasts consume the fallen on the battlefield, growing stronger and more twisted with each kill. They are brutal shock troops, relentless in their charge and devastating in their bite, embodying the death they now serve.", &"faction": 2, &"unit_type": 1, &"attacks": [{
 &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 0, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 35, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_archer_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
 "Poison": [20, 2]
 
} 
}]
, &"effects": [{
 &"effect_name": "Ward", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/ward.tscn", &"args": [3, 1]
 
}]
, &"base_damage": 65, &"max_hp": 450, &"armor": 10, &"evasion": 0.005, &"shielding_chance": 0.7 
},&"Death Acolyte" : {
 &"scene_path": "res://Combat/Units/Derived units//Undead/u10_acolyte.tscn", &"level": 1, &"large_unit": false, &"immunities": []
, &"description": "Acolytes are novice practitioners of necromancy, drawn to the allure of death\'s secrets. Though their abilities are limited, they can channel minor curses to aid their allies. With time and guidance, these fledgling necromancers can evolve into powerful wielders of dark magic.", &"faction": 2, &"unit_type": 2, &"attacks": [{
 &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 1, &"accuracy": 0.9, &"targets_needed": 1, &"initiative": 35, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_archer_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
  
} 
}]
, &"effects": []
, &"base_damage": 15, &"max_hp": 50, &"armor": 0, &"evasion": 0.045, &"shielding_chance": 0.7 
},&"Grave whisperer" : {
 &"scene_path": "res://Combat/Units/Derived units//Heroes/grave_whisperer.tscn", &"level": 1, &"large_unit": false, &"immunities": []
, &"description": "", &"faction": 1, &"unit_type": 0, &"attacks": [{
 &"damage_multiplier": 0.65, &"damage_override": false, &"is_heal": false, &"type": 0, &"accuracy": 0.8, &"targets_needed": 1, &"initiative": 65, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_melee_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
  
} 
}, {
 &"damage_multiplier": 0.95, &"damage_override": false, &"is_heal": false, &"type": 0, &"accuracy": 0.8, &"targets_needed": 1, &"initiative": 45, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_melee_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
  
} 
}]
, &"effects": [{
 &"effect_name": "Vamirism", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/vampirism.tscn", &"args": [0.35, true]
 
}]
, &"base_damage": 80, &"max_hp": 150, &"armor": 0, &"evasion": 0.05, &"shielding_chance": 0.7 
},&"Dame Seraphine" : {
 &"scene_path": "res://Combat/Units/Derived units//Heroes/dame_seraphine.tscn", &"level": 1, &"large_unit": false, &"immunities": []
, &"description": "", &"faction": 1, &"unit_type": 0, &"attacks": [{
 &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 0, &"accuracy": 0.8, &"targets_needed": 1, &"initiative": 0, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_melee_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
  
} 
}]
, &"effects": []
, &"base_damage": 70, &"max_hp": 200, &"armor": 20, &"evasion": 0.05, &"shielding_chance": 0.7 
},&"Virion the Bonebinder" : {
 &"scene_path": "res://Combat/Units/Derived units//Heroes/virion_the_bonebinder.tscn", &"level": 1, &"large_unit": false, &"immunities": []
, &"description": "", &"faction": 1, &"unit_type": 0, &"attacks": [{
 &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 3, &"accuracy": 0.8, &"targets_needed": 1, &"initiative": 0, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_mage_validity.tres", &"additional_targets": "res://Combat/Units/Parameters/Additional targets/Splash.tres", &"damage_policy": "res://Combat/Units/Parameters/Policy/decay_policy.tres", &"applying_effects": {
  
} 
}]
, &"effects": []
, &"base_damage": 50, &"max_hp": 170, &"armor": 15, &"evasion": 0.05, &"shielding_chance": 0.7 
},&"Knight Champion" : {
 &"scene_path": "res://Combat/Units/Derived units//Heroes/knight_champion.tscn", &"level": 1, &"large_unit": false, &"immunities": []
, &"description": "", &"faction": 1, &"unit_type": 0, &"attacks": [{
 &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 0, &"accuracy": 0.8, &"targets_needed": 1, &"initiative": 40, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_melee_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
  
} 
}]
, &"effects": []
, &"base_damage": 70, &"max_hp": 200, &"armor": 65, &"evasion": 0.05, &"shielding_chance": 0.7 
},&"Thymaël Doux, the Blade of Holy Light" : {
 &"scene_path": "res://Combat/Units/Derived units//Heroes/h02 thymaël_doux.tscn", &"level": 1, &"large_unit": false, &"immunities": []
, &"description": "", &"faction": 1, &"unit_type": 0, &"attacks": [{
 &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 0, &"accuracy": 0.85, &"targets_needed": 1, &"initiative": 45, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_melee_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
  
} 
}]
, &"effects": []
, &"base_damage": 80, &"max_hp": 200, &"armor": 40, &"evasion": 0.05, &"shielding_chance": 0.7 
},&"Cartographer" : {
 &"scene_path": "res://Combat/Units/Derived units//Heroes/cartographer.tscn", &"level": 1, &"large_unit": false, &"immunities": []
, &"description": "", &"faction": 1, &"unit_type": 0, &"attacks": [{
 &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 0, &"accuracy": 0.9, &"targets_needed": 1, &"initiative": 0, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_archer_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
 "Weakness": [1, 30]
 
} 
}]
, &"effects": []
, &"base_damage": 30, &"max_hp": 160, &"armor": 10, &"evasion": 0.05, &"shielding_chance": 0.7 
},&"Bone collector" : {
 &"scene_path": "res://Combat/Units/Derived units//Heroes/bone_collector.tscn", &"level": 1, &"large_unit": false, &"immunities": []
, &"description": "", &"faction": 1, &"unit_type": 0, &"attacks": [{
 &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 0, &"accuracy": 0.83, &"targets_needed": 1, &"initiative": 0, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_archer_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
 "vulnerability": [1, 15]
, "weakness": [1, 15]
 
} 
}]
, &"effects": []
, &"base_damage": 40, &"max_hp": 110, &"armor": 0, &"evasion": 0.05, &"shielding_chance": 0.7 
},&"Margrave Solreth" : {
 &"scene_path": "res://Combat/Units/Derived units//Heroes/margrave_solreth.tscn", &"level": 1, &"large_unit": false, &"immunities": []
, &"description": "", &"faction": 1, &"unit_type": 0, &"attacks": [{
 &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 3, &"accuracy": 0.8, &"targets_needed": 1, &"initiative": 30, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_mage_validity.tres", &"additional_targets": "res://Combat/Units/Parameters/Additional targets/standard_mage_targets.tres", &"damage_policy": "res://Combat/Units/Parameters/Policy/decay_policy.tres", &"applying_effects": {
  
} 
}]
, &"effects": []
, &"base_damage": 40, &"max_hp": 180, &"armor": 10, &"evasion": 0.05, &"shielding_chance": 0.7 
},&"High mage" : {
 &"scene_path": "res://Combat/Units/Derived units//Heroes/h01 High mage.tscn", &"level": 1, &"large_unit": false, &"immunities": []
, &"description": "", &"faction": 1, &"unit_type": 0, &"attacks": [{
 &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 0, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 0, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_mage_validity.tres", &"additional_targets": "res://Combat/Units/Parameters/Additional targets/standard_mage_targets.tres", &"damage_policy": "", &"applying_effects": {
  
} 
}]
, &"effects": []
, &"base_damage": 30, &"max_hp": 150, &"armor": 30, &"evasion": 0.05, &"shielding_chance": 0.7 
},&"Sir Roland" : {
 &"scene_path": "res://Combat/Units/Derived units//Heroes/sir_roland.tscn", &"level": 1, &"large_unit": false, &"immunities": []
, &"description": "", &"faction": 1, &"unit_type": 0, &"attacks": [{
 &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 0, &"accuracy": 0.8, &"targets_needed": 1, &"initiative": 0, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_melee_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
  
} 
}]
, &"effects": []
, &"base_damage": 60, &"max_hp": 200, &"armor": 40, &"evasion": 0.05, &"shielding_chance": 0.7 
},&"Marksman" : {
 &"scene_path": "res://Combat/Units/Derived units//Empire/e23 Marksman.tscn", &"level": 2, &"large_unit": false, &"immunities": []
, &"description": "Marksmen are archers who have honed their craft, wielding longbows for greater range and accuracy. Their arrows strike with precision, making them ideal for targeting critical threats or weakening heavily armored foes.", &"faction": 1, &"unit_type": 1, &"attacks": [{
 &"damage_multiplier": 0.5, &"damage_override": false, &"is_heal": false, &"type": 0, &"accuracy": 0.96, &"targets_needed": 1, &"initiative": 50, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_archer_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
  
} 
}, {
 &"damage_multiplier": 25.0, &"damage_override": true, &"is_heal": false, &"type": 0, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 35, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_archer_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
  
} 
}]
, &"effects": []
, &"base_damage": 45, &"max_hp": 75, &"armor": 0, &"evasion": 0.136, &"shielding_chance": 0.7 
},&"Witch hunter" : {
 &"scene_path": "res://Combat/Units/Derived units//Empire/e02 Witch hunter.tscn", &"level": 2, &"large_unit": false, &"immunities": []
, &"description": "Witch Hunters are zealous warriors trained to purge dark magic and heresy wherever it festers. Armed with specialized tools and unwavering faith, they excel at confronting spellcasters and disrupting their powers. Their knowledge of arcane threats makes them formidable foes against the unnatural.", &"faction": 1, &"unit_type": 0, &"attacks": [{
 &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 0, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 40, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_melee_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
  
} 
}]
, &"effects": []
, &"base_damage": 45, &"max_hp": 150, &"armor": 10, &"evasion": 0.1, &"shielding_chance": 0.7 
},&"Angel" : {
 &"scene_path": "res://Combat/Units/Derived units//Empire/e13 Angel.tscn", &"level": 5, &"large_unit": false, &"immunities": []
, &"description": "Angels are divine warriors, manifestations of the heavens\' will on the battlefield. With radiant wings and a sword imbued with holy power, they strike down the wicked with unrelenting precision. Their very presence bolsters the morale of allies, while their aura of purity weakens the resolve of foes. Angels are a testament to the faith and righteousness of those they protect, serving as both guardians and instruments of judgment.", &"faction": 1, &"unit_type": 0, &"attacks": [{
 &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 1, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 40, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/any_unit.tres", &"additional_targets": "", &"damage_policy": "res://Combat/Units/Parameters/Policy/purify_policy.tres", &"applying_effects": {
  
} 
}]
, &"effects": [{
 &"effect_name": "Armor buff Aura", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/armor_buff_aura.tscn", &"args": 30 
}, {
 &"effect_name": "Divine nature", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/cheat_death.tscn", &"args": [1, 1]
 
}]
, &"base_damage": 100, &"max_hp": 350, &"armor": 50, &"evasion": 0.05, &"shielding_chance": 0.7 
},&"Blade Saint" : {
 &"scene_path": "res://Combat/Units/Derived units//Empire/e08 Blade Saint.tscn", &"level": 4, &"large_unit": false, &"immunities": []
, &"description": "Blade Saints are legendary swordsmen whose mastery of the blade borders on the supernatural. Their movements are fluid and precise, cutting through enemies with unmatched grace and speed. Years of discipline and devotion to their craft have made them nearly invincible.", &"faction": 1, &"unit_type": 0, &"attacks": [{
 &"damage_multiplier": 0.65, &"damage_override": false, &"is_heal": false, &"type": 0, &"accuracy": 0.975, &"targets_needed": 2, &"initiative": 40, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_melee_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
  
} 
}]
, &"effects": [{
 &"effect_name": "Combo", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/combo.tscn", &"args": [30, 1.0]
 
}]
, &"base_damage": 80, &"max_hp": 275, &"armor": 35, &"evasion": 0.2, &"shielding_chance": 0.7 
},&"Priest" : {
 &"scene_path": "res://Combat/Units/Derived units//Empire/e29 Priest.tscn", &"level": 2, &"large_unit": false, &"immunities": []
, &"description": "Priests are experienced healers, capable of invoking potent divine blessings to restore a significant amount of health to a single ally. Their focused prayers can turn the tide of a skirmish by ensuring critical combatants remain in the fight.", &"faction": 1, &"unit_type": 3, &"attacks": [{
 &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": true, &"type": 3, &"accuracy": 1.0, &"targets_needed": 1, &"initiative": 10, &"evadable": false, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_healer_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
 "cure": null 
} 
}]
, &"effects": []
, &"base_damage": 40, &"max_hp": 110, &"armor": 0, &"evasion": 0.05, &"shielding_chance": 0.7 
},&"White Mage" : {
 &"scene_path": "res://Combat/Units/Derived units//Empire/e19 White Mage.tscn", &"level": 4, &"large_unit": false, &"immunities": []
, &"description": "The most powerful wizards are granted the title of White Mages. The storms they can summon on the battlefield can wipe out entire armies.", &"faction": 1, &"unit_type": 2, &"attacks": [{
 &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 1, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 70, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/any_unit.tres", &"additional_targets": "res://Combat/Units/Parameters/Additional targets/Splash.tres", &"damage_policy": "res://Combat/Units/Derived units/Empire/e19 White Mage.tscn::Resource_yeav1", &"applying_effects": {
 "electrified": [2, 10]
 
} 
}]
, &"effects": []
, &"base_damage": 55, &"max_hp": 180, &"armor": 0, &"evasion": 0.05, &"shielding_chance": 0.7 
},&"Imperial priest" : {
 &"scene_path": "res://Combat/Units/Derived units//Empire/e31 Imperial priest.tscn", &"level": 3, &"large_unit": false, &"immunities": []
, &"description": "Clergymen are stalwart defenders of faith and life, wielding potent healing magic to sustain their allies. Their unwavering devotion allows them to keep even gravely wounded warriors in the fray. They are a cornerstone of any formation, ensuring the survival of their party\'s strongest fighters.", &"faction": 1, &"unit_type": 3, &"attacks": [{
 &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": true, &"type": 3, &"accuracy": 1.0, &"targets_needed": 1, &"initiative": 10, &"evadable": false, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_healer_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
 "cure": null 
} 
}]
, &"effects": []
, &"base_damage": 60, &"max_hp": 150, &"armor": 0, &"evasion": 0.05, &"shielding_chance": 0.7 
},&"Apprentice" : {
 &"scene_path": "res://Combat/Units/Derived units//Empire/e14 Apprentice.tscn", &"level": 1, &"large_unit": false, &"immunities": []
, &"description": "Apprentices are fledgling mages taking their first steps into the arcane arts. Though their spells are simple and lack refinement, they can still unleash bursts of magical energy capable of turning the tide in smaller skirmishes. While fragile and inexperienced, they show great potential, embodying the raw promise of power yet to be mastered.", &"faction": 1, &"unit_type": 2, &"attacks": [{
 &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 1, &"accuracy": 0.9, &"targets_needed": 1, &"initiative": 30, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_mage_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
  
} 
}]
, &"effects": []
, &"base_damage": 20, &"max_hp": 50, &"armor": 0, &"evasion": 0.05, &"shielding_chance": 0.7 
},&"Assassin" : {
 &"scene_path": "res://Combat/Units/Derived units//Empire/e25 Assassin.tscn", &"level": 3, &"large_unit": false, &"immunities": []
, &"description": "Masters of shdows, assassins prefer poison over the raw strength.", &"faction": 1, &"unit_type": 1, &"attacks": [{
 &"damage_multiplier": 0.5, &"damage_override": false, &"is_heal": false, &"type": 0, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 50, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_archer_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
 "Poison": [15, 3]
 
} 
}, {
 &"damage_multiplier": 0.5, &"damage_override": false, &"is_heal": false, &"type": 0, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 50, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_archer_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
 "Poison": [20, 2]
 
} 
}]
, &"effects": [{
 &"effect_name": "Agility", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/agility.tscn", &"args": [2, 1.2]
 
}]
, &"base_damage": 75, &"max_hp": 85, &"armor": -20, &"evasion": 0.3, &"shielding_chance": 0.7 
},&"Paladin" : {
 &"scene_path": "res://Combat/Units/Derived units//Empire/e12 Paladin.tscn", &"level": 5, &"large_unit": false, &"immunities": []
, &"description": "Paladins are elite horsemen sworn to the king\'s service, their presence a testament to the kingdom\'s might. Mounted on powerful steeds clad in ornate armor, they charge into battle with unmatched speed and force, devastating enemy lines. Their discipline and training allow them to perform precision maneuvers, bolstering the effectiveness of allied forces.", &"faction": 1, &"unit_type": 0, &"attacks": [{
 &"damage_multiplier": 0.4, &"damage_override": false, &"is_heal": false, &"type": 0, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 70, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Derived units/Empire/e12 Paladin.tscn::Resource_rww7o", &"additional_targets": "", &"damage_policy": "res://Combat/Units/Parameters/Policy/melee_with_move_policy.tres", &"applying_effects": {
  
} 
}, {
 &"damage_multiplier": 0.5, &"damage_override": false, &"is_heal": false, &"type": 0, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 40, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Derived units/Empire/e12 Paladin.tscn::Resource_rww7o", &"additional_targets": "", &"damage_policy": "res://Combat/Units/Parameters/Policy/melee_with_move_policy.tres", &"applying_effects": {
  
} 
}, {
 &"damage_multiplier": 0.4, &"damage_override": false, &"is_heal": false, &"type": 0, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 30, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Derived units/Empire/e12 Paladin.tscn::Resource_rww7o", &"additional_targets": "", &"damage_policy": "res://Combat/Units/Parameters/Policy/melee_with_move_policy.tres", &"applying_effects": {
  
} 
}]
, &"effects": [{
 &"effect_name": "Giddy up", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/on_move_evasion_up.tscn", &"args": [1.7, 3]
 
}, {
 &"effect_name": "Damage buff Aura", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/damage_buff_aura.tscn", &"args": 40 
}]
, &"base_damage": 100, &"max_hp": 350, &"armor": 70, &"evasion": 0.05, &"shielding_chance": 0.8 
},&"Cleric" : {
 &"scene_path": "res://Combat/Units/Derived units//Empire/e28 Cleric.tscn", &"level": 2, &"large_unit": false, &"immunities": []
, &"description": "Clerics provide balanced healing to the entire party, spreading divine energy to mend multiple allies at once. Though their magic isn’t as potent as focused healers, their ability to stabilize the group makes them indispensable in prolonged battles.", &"faction": 1, &"unit_type": 3, &"attacks": [{
 &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": true, &"type": 3, &"accuracy": 1.0, &"targets_needed": 1, &"initiative": 0, &"evadable": false, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_healer_validity.tres", &"additional_targets": "res://Combat/Units/Parameters/Additional targets/mass_heal_targets.tres", &"damage_policy": "", &"applying_effects": {
  
} 
}]
, &"effects": []
, &"base_damage": 25, &"max_hp": 100, &"armor": 0, &"evasion": 0.05, &"shielding_chance": 0.7 
},&"Royal Cavalier" : {
 &"scene_path": "res://Combat/Units/Derived units//Empire/e11 Royal Cavalier.tscn", &"level": 4, &"large_unit": false, &"immunities": []
, &"description": "Royal Cavaliers are the backbone of the kingdom\'s mounted forces, blending power and precision. Equipped with finely crafted lances and sturdy armor, they excel at breaking enemy formations with calculated charges. Their training and discipline ensure they remain steadfast under pressure, offering reliable strength on the battlefield", &"faction": 1, &"unit_type": 0, &"attacks": [{
 &"damage_multiplier": 0.5, &"damage_override": false, &"is_heal": false, &"type": 0, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 60, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/melee_with_move.tres", &"additional_targets": "", &"damage_policy": "res://Combat/Units/Parameters/Policy/melee_with_move_policy.tres", &"applying_effects": {
  
} 
}, {
 &"damage_multiplier": 0.4, &"damage_override": false, &"is_heal": false, &"type": 0, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 40, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/melee_with_move.tres", &"additional_targets": "", &"damage_policy": "res://Combat/Units/Parameters/Policy/melee_with_move_policy.tres", &"applying_effects": {
  
} 
}, {
 &"damage_multiplier": 0.3, &"damage_override": false, &"is_heal": false, &"type": 0, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 35, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/melee_with_move.tres", &"additional_targets": "", &"damage_policy": "res://Combat/Units/Parameters/Policy/melee_with_move_policy.tres", &"applying_effects": {
  
} 
}]
, &"effects": [{
 &"effect_name": "Giddy up", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/on_move_evasion_up.tscn", &"args": [1.5, 1]
 
}]
, &"base_damage": 80, &"max_hp": 275, &"armor": 50, &"evasion": 0.05, &"shielding_chance": 0.7 
},&"Squire" : {
 &"scene_path": "res://Combat/Units/Derived units//Empire/e01 Squire.tscn", &"level": 1, &"large_unit": false, &"immunities": []
, &"description": "The squire is an eager trainee, taking their first steps toward knighthood. Though their armor is light and their skills unpolished, they stand bravely on the front lines. Often serving as assistants to knights, squires are willing to risk much to prove their worth.", &"faction": 1, &"unit_type": 0, &"attacks": [{
 &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 0, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 40, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_melee_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
  
} 
}]
, &"effects": []
, &"base_damage": 30, &"max_hp": 100, &"armor": 0, &"evasion": 0.05, &"shielding_chance": 0.7 
},&"Archer" : {
 &"scene_path": "res://Combat/Units/Derived units//Empire/e22 Archer.tscn", &"level": 1, &"large_unit": false, &"immunities": []
, &"description": "Archers are the backbone of any ranged offense, skilled in the art of precision and timing. Armed with simple bows, they provide consistent support from the backlines, picking off weaker targets or softening up foes before the main assault.", &"faction": 1, &"unit_type": 1, &"attacks": [{
 &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 0, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 50, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_archer_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
  
} 
}]
, &"effects": []
, &"base_damage": 30, &"max_hp": 50, &"armor": 0, &"evasion": 0.05, &"shielding_chance": 0.7 
},&"Imperial Ranger" : {
 &"scene_path": "res://Combat/Units/Derived units//Empire/e26 Imperial Ranger.tscn", &"level": 4, &"large_unit": false, &"immunities": []
, &"description": "The elite among archers, Imperial Rangers are masters of the bow and forest warfare. With unparalleled accuracy and exceptional survival skills, they can track and eliminate enemies from the shadows. Their arrows are often enhanced with specialized tips, capable of piercing even the strongest defenses.", &"faction": 1, &"unit_type": 1, &"attacks": [{
 &"damage_multiplier": 0.25, &"damage_override": false, &"is_heal": false, &"type": 0, &"accuracy": 0.985, &"targets_needed": 1, &"initiative": 40, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_archer_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
  
} 
}, {
 &"damage_multiplier": 0.25, &"damage_override": false, &"is_heal": false, &"type": 0, &"accuracy": 0.985, &"targets_needed": 1, &"initiative": 30, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_archer_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
  
} 
}, {
 &"damage_multiplier": 0.25, &"damage_override": false, &"is_heal": false, &"type": 0, &"accuracy": 0.985, &"targets_needed": 1, &"initiative": 20, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_archer_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
  
} 
}, {
 &"damage_multiplier": 0.25, &"damage_override": false, &"is_heal": false, &"type": 0, &"accuracy": 0.985, &"targets_needed": 1, &"initiative": 10, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_archer_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
  
} 
}]
, &"effects": [{
 &"effect_name": "Agility", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/agility.tscn", &"args": [2, 1.2]
 
}, {
 &"effect_name": "Assistance", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/assistance.tscn", &"args": 0.5 
}]
, &"base_damage": 80, &"max_hp": 140, &"armor": 0, &"evasion": 0.296, &"shielding_chance": 0.7 
},&"Grand Inquisitor" : {
 &"scene_path": "res://Combat/Units/Derived units//Empire/e09 Grand Inquisitor.tscn", &"level": 4, &"large_unit": false, &"immunities": []
, &"description": "Grand Inquisitors channel divine energy to manifest enormous spectral warhammers, delivering crushing blows that bypass magical defenses. Their presence on the battlefield bolsters the vitality of nearby allies, increasing their resilience against even the fiercest assaults. With unwavering conviction, they serve as both protectors and avengers, ensuring the light triumphs over darkness.", &"faction": 1, &"unit_type": 0, &"attacks": [{
 &"damage_multiplier": 0.85, &"damage_override": false, &"is_heal": false, &"type": 4, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 40, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_melee_validity.tres", &"additional_targets": "res://Combat/Units/Parameters/Additional targets/Splash.tres", &"damage_policy": "res://Combat/Units/Derived units/Empire/e09 Grand Inquisitor.tscn::Resource_6n8jw", &"applying_effects": {
  
} 
}]
, &"effects": [{
 &"effect_name": "HP buff Aura", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/hp_buff_aura.tscn", &"args": 50 
}, {
 &"effect_name": "Holy wrath", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/holy_wrath.tscn", &"args": [2, 1.3]
 
}, {
 &"effect_name": "Sturdy will", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/retaliation_on_debuff.tscn", &"args": 1.3 
}, {
 &"effect_name": "Purity", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/negative_effect_immune.tscn", &"args": null 
}]
, &"base_damage": 80, &"max_hp": 275, &"armor": 35, &"evasion": 0.15, &"shielding_chance": 0.6 
},&"Hierophant" : {
 &"scene_path": "res://Combat/Units/Derived units//Empire/e33 Hierophant.tscn", &"level": 4, &"large_unit": false, &"immunities": []
, &"description": "Hierophants are revered figures, blessed with the power to channel miracles. In addition to healing grievous injuries, they can resurrect fallen allies, bringing hope to even the bleakest battlefields. Their presence inspires courage, as their divine powers can restore both body and spirit.", &"faction": 1, &"unit_type": 3, &"attacks": [{
 &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": true, &"type": 3, &"accuracy": 1.0, &"targets_needed": 1, &"initiative": 15, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/resurrection_validation.tres", &"additional_targets": "", &"damage_policy": "res://Combat/Units/Parameters/Policy/resurrection_policy.tres", &"applying_effects": {
  
} 
}]
, &"effects": []
, &"base_damage": 80, &"max_hp": 180, &"armor": 0, &"evasion": 0.05, &"shielding_chance": 0.7 
},&"Ritualist" : {
 &"scene_path": "res://Combat/Units/Derived units//Empire/e17 Ritualist.tscn", &"level": 3, &"large_unit": false, &"immunities": []
, &"description": "Ritualists delve into ancient and forbidden rites, channeling their energy to summon otherworldly beings or cast powerful curses. Their unique strength lies in their ability to turn the tide of battle by conjuring allies from empty spaces on the battlefield.", &"faction": 1, &"unit_type": 2, &"attacks": [{
 &"damage_multiplier": 0.6, &"damage_override": false, &"is_heal": false, &"type": 1, &"accuracy": 0.95, &"targets_needed": 2, &"initiative": 30, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/elementalist_validity.tres", &"additional_targets": "", &"damage_policy": "res://Combat/Units/Parameters/Policy/elementalist_policy.tres", &"applying_effects": {
  
} 
}]
, &"effects": []
, &"base_damage": 45, &"max_hp": 120, &"armor": 0, &"evasion": 0.05, &"shielding_chance": 0.7 
},&"Inquisitor" : {
 &"scene_path": "res://Combat/Units/Derived units//Empire/e05 Inquisitor.tscn", &"level": 3, &"large_unit": false, &"immunities": []
, &"description": "Inquisitors are relentless hunters of heresy, wielding heavy maces to deliver unyielding punishment. Their attacks pierce through magical defenses, making them especially deadly against spellcasters and enchanted foes. Unshakable in their faith, they inspire their allies and bring fear to the corrupted. On the battlefield, an Inquisitor is a resolute force of righteousness, relentless in their pursuit of heretics and the unholy.", &"faction": 1, &"unit_type": 0, &"attacks": [{
 &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 4, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 40, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_melee_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
  
} 
}]
, &"effects": [{
 &"effect_name": "Sturdy will", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/retaliation_on_debuff.tscn", &"args": 1.2 
}, {
 &"effect_name": "Holy wrath", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/holy_wrath.tscn", &"args": [2, 1.3]
 
}, {
 &"effect_name": "Ward", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/ward.tscn", &"args": [2, 1]
 
}]
, &"base_damage": 60, &"max_hp": 200, &"armor": 20, &"evasion": 0.1, &"shielding_chance": 0.6 
},&"Knight" : {
 &"scene_path": "res://Combat/Units/Derived units//Empire/e03 Knight.tscn", &"level": 2, &"large_unit": false, &"immunities": []
, &"description": "Knights are the backbone of any noble army, embodying valor and discipline on the battlefield. Clad in sturdy armor and wielding weapons with practiced skill, they excel at defending their allies and striking down foes. Trained in the art of mounted and foot combat, they are versatile warriors capable of holding the line or leading a charge. Their unwavering resolve inspires those who fight beside them.", &"faction": 1, &"unit_type": 0, &"attacks": [{
 &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 0, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 40, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_melee_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
  
} 
}]
, &"effects": [{
 &"effect_name": "Taunt", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/taunt.tscn", &"args": [0.3, 1.0]
 
}]
, &"base_damage": 45, &"max_hp": 150, &"armor": 20, &"evasion": 0.05, &"shielding_chance": 0.7 
},&"Samurai" : {
 &"scene_path": "res://Combat/Units/Derived units//Empire/e04 Samurai.tscn", &"level": 3, &"large_unit": false, &"immunities": []
, &"description": "Samurai are elite warriors who combine unmatched discipline with masterful swordsmanship. Adhering to a strict code of honor, they are steadfast defenders of their allies, standing unyielding in the face of overwhelming odds. With swift, precise strikes and the ability to anticipate their foes\' moves, samurai can atack twice.", &"faction": 1, &"unit_type": 0, &"attacks": [{
 &"damage_multiplier": 0.56, &"damage_override": false, &"is_heal": false, &"type": 0, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 40, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_melee_validity.tres", &"additional_targets": "res://Combat/Units/Parameters/Additional targets/Double_attack.tres", &"damage_policy": "", &"applying_effects": {
  
} 
}]
, &"effects": []
, &"base_damage": 60, &"max_hp": 200, &"armor": 20, &"evasion": 0.15, &"shielding_chance": 0.7 
},&"Arcanist" : {
 &"scene_path": "res://Combat/Units/Derived units//Empire/e21 Arcanist.tscn", &"level": 5, &"large_unit": false, &"immunities": []
, &"description": "Arcanists are the pinnacle of arcane mastery, wielding devastating spells that reshape the battlefield. Their magic transcends the ordinary, unraveling enemy formations and wreaking havoc with immense elemental power. While physically fragile, their unparalleled command of destructive forces makes them a cornerstone of any strategy that seeks to overwhelm foes with raw magical might.", &"faction": 1, &"unit_type": 2, &"attacks": [{
 &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 1, &"accuracy": 0.85, &"targets_needed": 1, &"initiative": 0, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/any_unit.tres", &"additional_targets": "res://Combat/Units/Parameters/Additional targets/Splash.tres", &"damage_policy": "res://Combat/Units/Derived units/Empire/e21 Arcanist.tscn::Resource_xbk8a", &"applying_effects": {
 "electrified": [3, 18]
 
} 
}]
, &"effects": [{
 &"effect_name": "Defender", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/protect_on_attack.tscn", &"args": [50, true, 0.5, 0.3, -1]
 
}, {
 &"effect_name": "Retaliation", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/retaliation.tscn", &"args": [30, {
 &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 1, &"accuracy": 1.0, &"targets_needed": 1, &"initiative": 0, &"evadable": false, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_mage_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
  
} 
}]
 
}]
, &"base_damage": 80, &"max_hp": 200, &"armor": 15, &"evasion": 0.05, &"shielding_chance": 0.7 
},&"Angel Knight" : {
 &"scene_path": "res://Combat/Units/Derived units//Empire/e10 Angel Knight.tscn", &"level": 4, &"large_unit": false, &"immunities": []
, &"description": "Angel Knights are celestial warriors clad in radiant armor, wielding swords blessed with divine power. Their strikes are swift and unerring, cutting through darkness and doubt with righteous precision. With their holy aura, they inspire nearby allies, enhancing their offensive capabilities.", &"faction": 1, &"unit_type": 0, &"attacks": [{
 &"damage_multiplier": 0.5, &"damage_override": false, &"is_heal": false, &"type": 1, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 40, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/melee_with_self.tres", &"additional_targets": "", &"damage_policy": "res://Combat/Units/Derived units/Empire/e10 Angel Knight.tscn::Resource_5c7t2", &"applying_effects": {
  
} 
}, {
 &"damage_multiplier": 0.5, &"damage_override": false, &"is_heal": false, &"type": 1, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 30, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/melee_with_self.tres", &"additional_targets": "", &"damage_policy": "res://Combat/Units/Derived units/Empire/e10 Angel Knight.tscn::Resource_5c7t2", &"applying_effects": {
  
} 
}]
, &"effects": [{
 &"effect_name": "Divine nature", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/cheat_death.tscn", &"args": [1, 1]
 
}, {
 &"effect_name": "Taunt", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/taunt.tscn", &"args": [0.5, 0.55]
 
}, {
 &"effect_name": "Healing aura", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/on_turn_heal.tscn", &"args": 25 
}]
, &"base_damage": 80, &"max_hp": 275, &"armor": 80, &"evasion": 0.05, &"shielding_chance": 0.85 
},&"Keeper of Knowledge" : {
 &"scene_path": "res://Combat/Units/Derived units//Empire/e20 Keeper of Knowledge.tscn", &"level": 5, &"large_unit": false, &"immunities": []
, &"description": "The Keeper of Knowledge is both a scholar and a mage, delving into ancient tomes to uncover secrets lost to time. They channel this wisdom into powerful spells that disrupt enemies and empower allies. Masters of manipulation, they can alter the flow of battle with their insight, ensuring their allies have every advantage while their enemies falter under the weight of forgotten truths.", &"faction": 1, &"unit_type": 2, &"attacks": [{
 &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 1, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 30, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/any_unit.tres", &"additional_targets": "", &"damage_policy": "res://Combat/Units/Parameters/Policy/filter_allies_policy.tres", &"applying_effects": {
 "exposed": 2 
} 
}]
, &"effects": [{
 &"effect_name": "All-knowing", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/change_attack_type.tscn", &"args": 2 
}]
, &"base_damage": 100, &"max_hp": 200, &"armor": 0, &"evasion": 0.05, &"shielding_chance": 0.7 
},&"Wizard" : {
 &"scene_path": "res://Combat/Units/Derived units//Empire/e18 Wizard.tscn", &"level": 3, &"large_unit": false, &"immunities": []
, &"description": "Wizards are masters of advanced arcane arts, capable of reshaping the battlefield with devastating spells and area control. Their ability to manipulate energy allows them to strike multiple enemies or weaken their defenses with precision.", &"faction": 1, &"unit_type": 2, &"attacks": [{
 &"damage_multiplier": 0.85, &"damage_override": false, &"is_heal": false, &"type": 1, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 30, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/any_unit.tres", &"additional_targets": "res://Combat/Units/Parameters/Additional targets/Splash.tres", &"damage_policy": "res://Combat/Units/Parameters/Policy/applying_shield_policy.tres", &"applying_effects": {
  
} 
}]
, &"effects": []
, &"base_damage": 45, &"max_hp": 110, &"armor": 0, &"evasion": 0.05, &"shielding_chance": 0.7 
},&"Mage" : {
 &"scene_path": "res://Combat/Units/Derived units//Empire/e16 Mage.tscn", &"level": 2, &"large_unit": false, &"immunities": []
, &"description": "Mages are practitioners of refined arcane knowledge, capable of channeling powerful spells to damage foes. However, their focus on spellcasting leaves them physically vulnerable, relying on careful positioning and team support to maximize their potential.", &"faction": 1, &"unit_type": 2, &"attacks": [{
 &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 1, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 30, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/any_unit.tres", &"additional_targets": "", &"damage_policy": "res://Combat/Units/Derived units/Empire/e16 Mage.tscn::Resource_6f3w4", &"applying_effects": {
  
} 
}]
, &"effects": []
, &"base_damage": 30, &"max_hp": 75, &"armor": 0, &"evasion": 0.05, &"shielding_chance": 0.7 
},&"Scout" : {
 &"scene_path": "res://Combat/Units/Derived units//Empire/e24 Scout.tscn", &"level": 3, &"large_unit": false, &"immunities": []
, &"description": "Scouts are nimble and resourceful, blending speed with precision. They excel at quick strikes and harassing enemy formations. Their agility allows them to avoid direct confrontation, making them invaluable for reconnaissance and flanking maneuvers in tactical skirmishes.", &"faction": 1, &"unit_type": 1, &"attacks": [{
 &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 0, &"accuracy": 0.97, &"targets_needed": 1, &"initiative": 50, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_archer_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
 "vulnerability": [1, 30]
 
} 
}, {
 &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 0, &"accuracy": 0.97, &"targets_needed": 1, &"initiative": 50, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_archer_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
  
} 
}]
, &"effects": [{
 &"effect_name": "Agility", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/agility.tscn", &"args": [2, 0.0]
 
}]
, &"base_damage": 60, &"max_hp": 100, &"armor": 0, &"evasion": 0.208, &"shielding_chance": 0.7 
},&"Knight Master" : {
 &"scene_path": "res://Combat/Units/Derived units//Empire/e06 Knight Master.tscn", &"level": 3, &"large_unit": false, &"immunities": []
, &"description": "Knight Masters are paragons of martial skill, commanding respect on the battlefield with their imposing presence and unwavering discipline. Equipped with masterfully crafted armor and weapons, they excel in both offense and defense, standing as stalwart protectors of their allies. A Knight Master is a symbol of honor and strength, embodying the virtues of their order.", &"faction": 1, &"unit_type": 0, &"attacks": [{
 &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 0, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 40, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/melee_with_self.tres", &"additional_targets": "", &"damage_policy": "res://Combat/Units/Parameters/Policy/provoke_valid_targets_policy.tres", &"applying_effects": {
  
} 
}]
, &"effects": [{
 &"effect_name": "Taunt", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/taunt.tscn", &"args": [0.4, 0.65]
 
}]
, &"base_damage": 60, &"max_hp": 200, &"armor": 50, &"evasion": 0.05, &"shielding_chance": 0.7 
},&"Horseman" : {
 &"scene_path": "res://Combat/Units/Derived units//Empire/e07 Horseman.tscn", &"level": 3, &"large_unit": false, &"immunities": []
, &"description": "Horsemen are swift and adaptable warriors who rely on speed and maneuverability to outflank enemies and strike with precision. Their mobility makes them invaluable for rapid assaults or defensive countermeasures. A Horseman’s strength lies not only in their combat prowess but in their ability to turn the tide of battle with quick and decisive actions.", &"faction": 1, &"unit_type": 0, &"attacks": [{
 &"damage_multiplier": 0.4, &"damage_override": false, &"is_heal": false, &"type": 0, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 70, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/melee_with_move.tres", &"additional_targets": "", &"damage_policy": "res://Combat/Units/Parameters/Policy/melee_with_move_policy.tres", &"applying_effects": {
  
} 
}, {
 &"damage_multiplier": 0.6, &"damage_override": false, &"is_heal": false, &"type": 0, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 40, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/melee_with_move.tres", &"additional_targets": "", &"damage_policy": "res://Combat/Units/Parameters/Policy/melee_with_move_policy.tres", &"applying_effects": {
  
} 
}]
, &"effects": []
, &"base_damage": 60, &"max_hp": 200, &"armor": 35, &"evasion": 0.05, &"shielding_chance": 0.7 
},&"Elementalist" : {
 &"scene_path": "res://Combat/Units/Derived units//Empire/e15 Elementalist.tscn", &"level": 2, &"large_unit": false, &"immunities": []
, &"description": "Elementalists are specialists who wield the raw forces of nature, calling upon the elements to devastate their enemies. Their mastery of summoning allows them to conjure elemental creatures to fight alongside them, disrupting enemy formations.", &"faction": 1, &"unit_type": 2, &"attacks": [{
 &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 1, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 30, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/elementalist_validity.tres", &"additional_targets": "", &"damage_policy": "res://Combat/Units/Parameters/Policy/elementalist_policy.tres", &"applying_effects": {
  
} 
}]
, &"effects": []
, &"base_damage": 30, &"max_hp": 75, &"armor": 0, &"evasion": 0.05, &"shielding_chance": 0.7 
},&"Matriarch" : {
 &"scene_path": "res://Combat/Units/Derived units//Empire/e30 Matriarch.tscn", &"level": 3, &"large_unit": false, &"immunities": []
, &"description": "Matriarchs are pillars of divine strength, safeguarding the vitality of their entire party. Their healing magic envelops all allies, keeping them resilient against the relentless tides of war. Their presence fosters unity and endurance among their comrades.", &"faction": 1, &"unit_type": 3, &"attacks": [{
 &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": true, &"type": 3, &"accuracy": 1.0, &"targets_needed": 1, &"initiative": 10, &"evadable": false, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_healer_validity.tres", &"additional_targets": "res://Combat/Units/Parameters/Additional targets/mass_heal_targets.tres", &"damage_policy": "", &"applying_effects": {
 "random_buff": [1, 5, 1.1]
 
} 
}]
, &"effects": []
, &"base_damage": 45, &"max_hp": 150, &"armor": 0, &"evasion": 0.05, &"shielding_chance": 0.7 
},&"Acolyte" : {
 &"scene_path": "res://Combat/Units/Derived units//Empire/e27 Acolyte.tscn", &"level": 1, &"large_unit": false, &"immunities": []
, &"description": "Acolytes are the fledgling healers of the faith, channeling divine energy to mend the wounds of their allies. While their healing power is limited, their dedication to protecting their comrades is unwavering.", &"faction": 1, &"unit_type": 3, &"attacks": [{
 &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": true, &"type": 3, &"accuracy": 1.0, &"targets_needed": 1, &"initiative": 10, &"evadable": false, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_healer_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
  
} 
}]
, &"effects": []
, &"base_damage": 20, &"max_hp": 70, &"armor": 0, &"evasion": 0.05, &"shielding_chance": 0.7 
},&"Prophetess" : {
 &"scene_path": "res://Combat/Units/Derived units//Empire/e32 Prophetess.tscn", &"level": 1, &"large_unit": false, &"immunities": []
, &"description": "Prophetesses wield extraordinary magic, providing powerful healing to their entire party. Their blessings not only mend wounds but also imbue allies with a sense of divine purpose. On the battlefield, they act as guiding lights, ensuring their comrades endure even the most grueling trials.", &"faction": 1, &"unit_type": 3, &"attacks": [{
 &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": true, &"type": 3, &"accuracy": 1.0, &"targets_needed": 1, &"initiative": 10, &"evadable": false, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_healer_validity.tres", &"additional_targets": "res://Combat/Units/Parameters/Additional targets/mass_heal_targets.tres", &"damage_policy": "", &"applying_effects": {
 "random_buff": [2, 10, 1.15]
 
} 
}]
, &"effects": []
, &"base_damage": 65, &"max_hp": 195, &"armor": 0, &"evasion": 0.05, &"shielding_chance": 0.7 
},&"Orc" : {
 &"scene_path": "res://Combat/Units/Derived units//Neutral/orc.tscn", &"level": 2, &"large_unit": false, &"immunities": []
, &"description": "Orcs are fearsome warriors known for their brute strength and relentless aggression. They thrive in battle, often overpowering their foes with sheer force and determination. While they lack finesse, their loyalty to their clan and ferocity make them a dangerous presence on the battlefield.", &"faction": 8, &"unit_type": 0, &"attacks": [{
 &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 0, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 30, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_melee_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
  
} 
}]
, &"effects": []
, &"base_damage": 45, &"max_hp": 150, &"armor": 10, &"evasion": 0.05, &"shielding_chance": 0.7 
},&"Orc cheiftain" : {
 &"scene_path": "res://Combat/Units/Derived units//Neutral/orc_cheiftain.tscn", &"level": 4, &"large_unit": false, &"immunities": []
, &"description": "Orc Chieftains are the leaders of their clans, commanding respect through strength and cunning. They inspire their kin with battle cries and powerful strikes, rallying their forces to victory.", &"faction": 8, &"unit_type": 0, &"attacks": [{
 &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 0, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 40, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_melee_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
  
} 
}]
, &"effects": []
, &"base_damage": 80, &"max_hp": 275, &"armor": 35, &"evasion": 0.05, &"shielding_chance": 0.7 
},&"Pirate capitan" : {
 &"scene_path": "res://Combat/Units/Derived units//Neutral/pirate_captain.tscn", &"level": 4, &"large_unit": false, &"immunities": []
, &"description": "Pirate Captains are charismatic and ruthless leaders, commanding their crews with a mix of fear and admiration. Their combat skills are matched by their ability to inspire their followers, turning a ragtag crew into a formidable fighting force.", &"faction": 6, &"unit_type": 0, &"attacks": [{
 &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 0, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 40, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_melee_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
  
} 
}]
, &"effects": []
, &"base_damage": 90, &"max_hp": 275, &"armor": 20, &"evasion": 0.1, &"shielding_chance": 0.3 
},&"Rogue" : {
 &"scene_path": "res://Combat/Units/Derived units//Neutral/rogue.tscn", &"level": 2, &"large_unit": false, &"immunities": []
, &"description": "Rogues are seasoned fighters who blend agility and combat prowess, striking quickly and decisively. They are masters of deception, often using dirty tricks to gain the upper hand. Though they prefer to avoid direct confrontation, their versatility makes them a dangerous adversary.", &"faction": 7, &"unit_type": 0, &"attacks": [{
 &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 0, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 60, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_melee_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
 "poison": [10, 3]
 
} 
}, {
 &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 0, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 45, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_melee_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
 "poison": [10, 3]
 
} 
}, {
 &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 0, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 30, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_melee_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
 "poison": [10, 3]
 
} 
}]
, &"effects": []
, &"base_damage": 30, &"max_hp": 150, &"armor": 0, &"evasion": 0.05, &"shielding_chance": 0.7 
},&"Ogre" : {
 &"scene_path": "res://Combat/Units/Derived units//Neutral/ogre.tscn", &"level": 2, &"large_unit": true, &"immunities": []
, &"description": "Ogres are hulking brutes with unparalleled physical power, smashing through enemies and obstacles alike. Though not known for their intelligence, their immense strength and resilience make them formidable foes. These behemoths are often used as shock troops, devastating enemy ranks with crushing blows.", &"faction": 8, &"unit_type": 0, &"attacks": [{
 &"damage_multiplier": 0.5, &"damage_override": false, &"is_heal": false, &"type": 0, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 15, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_melee_validity.tres", &"additional_targets": "res://Combat/Units/Parameters/Additional targets/Double_attack.tres", &"damage_policy": "", &"applying_effects": {
  
} 
}]
, &"effects": []
, &"base_damage": 130, &"max_hp": 450, &"armor": 30, &"evasion": 0.01, &"shielding_chance": 0.7 
},&"Goblin" : {
 &"scene_path": "res://Combat/Units/Derived units//Neutral/goblin.tscn", &"level": 1, &"large_unit": false, &"immunities": []
, &"description": "Goblin Archers are small but surprisingly deadly, using their agility to stay out of reach while raining arrows on their enemies. Though their aim can be erratic, their sheer numbers often compensate for individual accuracy. They are often deployed as harassers, chipping away at enemy forces from a safe distance.", &"faction": 8, &"unit_type": 1, &"attacks": [{
 &"damage_multiplier": 0.667, &"damage_override": false, &"is_heal": false, &"type": 0, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 40, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_archer_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
  
} 
}, {
 &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 0, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 40, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_archer_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
  
} 
}]
, &"effects": []
, &"base_damage": 30, &"max_hp": 100, &"armor": 0, &"evasion": 0.1, &"shielding_chance": 0.7 
},&"Robber" : {
 &"scene_path": "res://Combat/Units/Derived units//Neutral/robber.tscn", &"level": 2, &"large_unit": false, &"immunities": []
, &"description": "", &"faction": 7, &"unit_type": 0, &"attacks": [{
 &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 0, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 0, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_melee_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
  
} 
}]
, &"effects": []
, &"base_damage": 30, &"max_hp": 100, &"armor": 0, &"evasion": 0.05, &"shielding_chance": 0.7 
},&"Pirate" : {
 &"scene_path": "res://Combat/Units/Derived units//Neutral/pirate.tscn", &"level": 3, &"large_unit": false, &"immunities": []
, &"description": "Pirates are rowdy and fearless, driven by a lust for gold and adventure. Armed with an array of mismatched weapons, they thrive in chaotic battles where their opportunistic nature shines. Their unpredictability and savage fighting style make them a force to be reckoned with.", &"faction": 6, &"unit_type": 0, &"attacks": [{
 &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 0, &"accuracy": 0.95, &"targets_needed": 2, &"initiative": 40, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_melee_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
  
} 
}]
, &"effects": []
, &"base_damage": 75, &"max_hp": 180, &"armor": 10, &"evasion": 0.08, &"shielding_chance": 0.0 
},&"Goblin shaman" : {
 &"scene_path": "res://Combat/Units/Derived units//Neutral/goblin_shaman.tscn", &"level": 2, &"large_unit": false, &"immunities": []
, &"description": "Goblin Shamans wield primitive but potent magic, channeling the chaotic energy of their tribe’s spirit rituals. They serve as both support and disruptors, casting spells that weaken enemies or bolster their allies.", &"faction": 8, &"unit_type": 2, &"attacks": [{
 &"damage_multiplier": 0.35, &"damage_override": false, &"is_heal": false, &"type": 1, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 15, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_mage_validity.tres", &"additional_targets": "res://Combat/Units/Parameters/Additional targets/standard_mage_targets.tres", &"damage_policy": "", &"applying_effects": {
  
} 
}]
, &"effects": []
, &"base_damage": 45, &"max_hp": 75, &"armor": 10, &"evasion": 0.1, &"shielding_chance": 0.7 
},&"Thief" : {
 &"scene_path": "res://Combat/Units/Derived units//Neutral/thief.tscn", &"level": 1, &"large_unit": false, &"immunities": []
, &"description": "Thieves are nimble and cunning, excelling in stealth and precision strikes. They specialize in exploiting enemy weaknesses, targeting vulnerabilities for devastating effect.", &"faction": 1, &"unit_type": 0, &"attacks": [{
 &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 0, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 65, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_melee_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
  
} 
}, {
 &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 0, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 30, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_melee_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
  
} 
}]
, &"effects": []
, &"base_damage": 25, &"max_hp": 100, &"armor": 0, &"evasion": 0.05, &"shielding_chance": 0.7 
},&"Elemental" : {
 &"scene_path": "res://Combat/Units/Derived units//Elemental.tscn", &"level": 1, &"large_unit": false, &"immunities": []
, &"description": "", &"faction": 6, &"unit_type": 2, &"attacks": [{
 &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 1, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 40, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_archer_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
  
} 
}]
, &"effects": []
, &"base_damage": 30, &"max_hp": 100, &"armor": 0, &"evasion": 0.1, &"shielding_chance": 0.7 
},
# end of database
}
