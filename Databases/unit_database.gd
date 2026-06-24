const database = {
&"Bone collector" : {
 &"scene_path": "res://Combat/Units/Derived units//Heroes/bone_collector.tscn", &"level": 1, &"large_unit": false, &"immunities": []
, &"description": "Bone Collectors offer their sight to the King of Necropolis and serve as his eyes in this world, and with every cursed bone they lay, they stitch another piece of the land into his dark tapestry.", &"brief_description": "Rod planter.", &"faction": 1, &"unit_type": 3, &"unit_class": 0, &"needed_xp": 300, &"attacks": [{
 &"attack_name": "Attack", &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 3, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 0, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_archer_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
 "vulnerability": [1, 15]
, "weakness": [1, 15]
 
}, &"animation_index": 0, &"alternative_actions": []
 
}]
, &"effects": []
, &"base_damage": 40, &"max_hp": 110, &"armor": 0, &"evasion": 0.05, &"shielding_chance": 0.7, &"portrait_texture_path": "", &"custom_levelup_path": "", &"hero_abilities": "", &"map_effects": {
  
}, &"cost": {
 &"gold": 300, &"stone": 50, &"mana": 50 
} 
},&"Virion the Bonebinder" : {
 &"scene_path": "res://Combat/Units/Derived units//Heroes/virion_the_bonebinder.tscn", &"level": 1, &"large_unit": false, &"immunities": []
, &"description": "", &"brief_description": "", &"faction": 1, &"unit_type": 2, &"unit_class": 0, &"needed_xp": 400, &"attacks": [{
 &"attack_name": "Attack", &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 3, &"accuracy": 0.8, &"targets_needed": 1, &"initiative": 0, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_mage_validity.tres", &"additional_targets": "res://Combat/Units/Parameters/Additional targets/Splash.tres", &"damage_policy": "res://Combat/Units/Parameters/Policy/decay_policy.tres", &"applying_effects": {
  
}, &"animation_index": 0, &"alternative_actions": []
 
}]
, &"effects": []
, &"base_damage": 50, &"max_hp": 170, &"armor": 15, &"evasion": 0.05, &"shielding_chance": 0.7, &"portrait_texture_path": "", &"custom_levelup_path": "", &"hero_abilities": "", &"map_effects": {
  
}, &"cost": {
 &"gold": 500, &"stone": 100, &"mana": 100 
} 
},&"Thymaël Doux" : {
 &"scene_path": "res://Combat/Units/Derived units//Heroes/h02 thymaël_doux.tscn", &"level": 1, &"large_unit": false, &"immunities": []
, &"description": "", &"brief_description": "", &"faction": 1, &"unit_type": 4, &"unit_class": 0, &"needed_xp": 400, &"attacks": [{
 &"attack_name": "Attack", &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 0, &"accuracy": 0.85, &"targets_needed": 1, &"initiative": 45, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_melee_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
  
}, &"animation_index": 0, &"alternative_actions": []
 
}]
, &"effects": [{
 &"effect_name": "Divine nature", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/cheat_death.tscn", &"args": [1, 1]
 
}]
, &"base_damage": 80, &"max_hp": 200, &"armor": 40, &"evasion": 0.05, &"shielding_chance": 0.7, &"portrait_texture_path": "", &"custom_levelup_path": "", &"hero_abilities": "", &"map_effects": {
  
}, &"cost": {
 &"gold": 500, &"stone": 100, &"mana": 100 
} 
},&"Margrave Solreth" : {
 &"scene_path": "res://Combat/Units/Derived units//Heroes/margrave_solreth.tscn", &"level": 1, &"large_unit": false, &"immunities": []
, &"description": "", &"brief_description": "", &"faction": 1, &"unit_type": 2, &"unit_class": 0, &"needed_xp": 1, &"attacks": [{
 &"attack_name": "Attack", &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 3, &"accuracy": 0.8, &"targets_needed": 1, &"initiative": 30, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_mage_validity.tres", &"additional_targets": "res://Combat/Units/Parameters/Additional targets/standard_mage_targets.tres", &"damage_policy": "res://Combat/Units/Parameters/Policy/decay_policy.tres", &"applying_effects": {
  
}, &"animation_index": 0, &"alternative_actions": []
 
}]
, &"effects": []
, &"base_damage": 40, &"max_hp": 180, &"armor": 10, &"evasion": 0.05, &"shielding_chance": 0.7, &"portrait_texture_path": "", &"custom_levelup_path": "", &"hero_abilities": "", &"map_effects": {
  
}, &"cost": {
 &"gold": 500, &"stone": 100, &"mana": 100 
} 
},&"Knight Champion" : {
 &"scene_path": "res://Combat/Units/Derived units//Heroes/knight_champion.tscn", &"level": 1, &"large_unit": false, &"immunities": []
, &"description": "", &"brief_description": "", &"faction": 1, &"unit_type": 4, &"unit_class": 0, &"needed_xp": 350, &"attacks": [{
 &"attack_name": "Attack", &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 0, &"accuracy": 0.8, &"targets_needed": 1, &"initiative": 40, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_melee_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
  
}, &"animation_index": 0, &"alternative_actions": []
 
}]
, &"effects": []
, &"base_damage": 70, &"max_hp": 200, &"armor": 65, &"evasion": 0.05, &"shielding_chance": 0.7, &"portrait_texture_path": "", &"custom_levelup_path": "", &"hero_abilities": "", &"map_effects": {
  
}, &"cost": {
 &"gold": 400, &"stone": 0, &"mana": 0 
} 
},&"Cartographer" : {
 &"scene_path": "res://Combat/Units/Derived units//Heroes/cartographer.tscn", &"level": 1, &"large_unit": false, &"immunities": []
, &"description": "Cartographers explore new lands and claim valuable resources for The Empire.", &"brief_description": "Rod planter.", &"faction": 1, &"unit_type": 1, &"unit_class": 0, &"needed_xp": 300, &"attacks": [{
 &"attack_name": "Attack", &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 0, &"accuracy": 0.9, &"targets_needed": 1, &"initiative": 0, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_archer_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
 "Weakness": [1, 30]
 
}, &"animation_index": 0, &"alternative_actions": []
 
}]
, &"effects": []
, &"base_damage": 30, &"max_hp": 160, &"armor": 10, &"evasion": 0.05, &"shielding_chance": 0.7, &"portrait_texture_path": "", &"custom_levelup_path": "", &"hero_abilities": "", &"map_effects": {
  
}, &"cost": {
 &"gold": 300, &"stone": 50, &"mana": 50 
} 
},&"Sir Roland" : {
 &"scene_path": "res://Combat/Units/Derived units//Heroes/sir_roland.tscn", &"level": 1, &"large_unit": false, &"immunities": []
, &"description": "", &"brief_description": "", &"faction": 1, &"unit_type": 4, &"unit_class": 0, &"needed_xp": 400, &"attacks": [{
 &"attack_name": "Attack", &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 0, &"accuracy": 0.8, &"targets_needed": 1, &"initiative": 0, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_melee_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
  
}, &"animation_index": 0, &"alternative_actions": []
 
}]
, &"effects": []
, &"base_damage": 60, &"max_hp": 200, &"armor": 40, &"evasion": 0.05, &"shielding_chance": 0.7, &"portrait_texture_path": "", &"custom_levelup_path": "", &"hero_abilities": "", &"map_effects": {
  
}, &"cost": {
 &"gold": 500, &"stone": 100, &"mana": 100 
} 
},&"High mage" : {
 &"scene_path": "res://Combat/Units/Derived units//Heroes/h01 High mage.tscn", &"level": 1, &"large_unit": false, &"immunities": []
, &"description": "", &"brief_description": "", &"faction": 1, &"unit_type": 4, &"unit_class": 0, &"needed_xp": 400, &"attacks": [{
 &"attack_name": "Attack", &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 0, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 0, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_mage_validity.tres", &"additional_targets": "res://Combat/Units/Parameters/Additional targets/standard_mage_targets.tres", &"damage_policy": "", &"applying_effects": {
  
}, &"animation_index": 0, &"alternative_actions": []
 
}]
, &"effects": []
, &"base_damage": 30, &"max_hp": 150, &"armor": 30, &"evasion": 0.05, &"shielding_chance": 0.7, &"portrait_texture_path": "", &"custom_levelup_path": "", &"hero_abilities": "", &"map_effects": {
  
}, &"cost": {
 &"gold": 500, &"stone": 100, &"mana": 100 
} 
},&"Dame The Seraph" : {
 &"scene_path": "res://Combat/Units/Derived units//Heroes/dame_seraphine.tscn", &"level": 1, &"large_unit": false, &"immunities": []
, &"description": "", &"brief_description": "", &"faction": 1, &"unit_type": 4, &"unit_class": 0, &"needed_xp": 400, &"attacks": [{
 &"attack_name": "Attack", &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 0, &"accuracy": 0.8, &"targets_needed": 1, &"initiative": 0, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_melee_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
  
}, &"animation_index": 0, &"alternative_actions": []
 
}]
, &"effects": []
, &"base_damage": 70, &"max_hp": 200, &"armor": 20, &"evasion": 0.05, &"shielding_chance": 0.7, &"portrait_texture_path": "", &"custom_levelup_path": "", &"hero_abilities": "", &"map_effects": {
  
}, &"cost": {
 &"gold": 500, &"stone": 100, &"mana": 100 
} 
},&"Grave whisperer" : {
 &"scene_path": "res://Combat/Units/Derived units//Heroes/grave_whisperer.tscn", &"level": 1, &"large_unit": false, &"immunities": []
, &"description": "", &"brief_description": "", &"faction": 1, &"unit_type": 4, &"unit_class": 0, &"needed_xp": 350, &"attacks": [{
 &"attack_name": "Attack", &"damage_multiplier": 0.65, &"damage_override": false, &"is_heal": false, &"type": 0, &"accuracy": 0.8, &"targets_needed": 1, &"initiative": 65, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_melee_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
  
}, &"animation_index": 0, &"alternative_actions": []
 
}, {
 &"attack_name": "Attack", &"damage_multiplier": 0.95, &"damage_override": false, &"is_heal": false, &"type": 0, &"accuracy": 0.8, &"targets_needed": 1, &"initiative": 45, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_melee_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
  
}, &"animation_index": 0, &"alternative_actions": []
 
}]
, &"effects": [{
 &"effect_name": "Vamirism", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/vampirism.tscn", &"args": [0.35, true]
 
}]
, &"base_damage": 80, &"max_hp": 150, &"armor": 0, &"evasion": 0.05, &"shielding_chance": 0.7, &"portrait_texture_path": "", &"custom_levelup_path": "", &"hero_abilities": "", &"map_effects": {
  
}, &"cost": {
 &"gold": 400, &"stone": 0, &"mana": 0 
} 
},&"Archlich" : {
 &"scene_path": "res://Combat/Units/Derived units//Undead/u17_archlich.tscn", &"level": 4, &"large_unit": false, &"immunities": [3]
, &"description": "The strongest of the Necropolis\' mages bear the name of Archliches. These beings can bend life and death to their will. Nothing alive can stand in their way, and nothing dead can resist their command.", &"brief_description": "Weak mage with ability to resurrect and two double actions per round.", &"faction": 2, &"unit_type": 2, &"unit_class": 5, &"needed_xp": 1600, &"attacks": [{
 &"attack_name": "Attack", &"damage_multiplier": 0.3, &"damage_override": false, &"is_heal": false, &"type": 1, &"accuracy": 0.95, &"targets_needed": 2, &"initiative": 30, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/necromancer_validity.tres", &"additional_targets": "", &"damage_policy": "res://Combat/Units/Derived units/Undead/u17_archlich.tscn::Resource_avfpn", &"applying_effects": {
 "death_curse": [-1, 10]
 
}, &"animation_index": 0, &"alternative_actions": []
 
}, {
 &"attack_name": "Attack", &"damage_multiplier": 0.2, &"damage_override": false, &"is_heal": false, &"type": 1, &"accuracy": 0.95, &"targets_needed": 2, &"initiative": 30, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/necromancer_validity.tres", &"additional_targets": "", &"damage_policy": "res://Combat/Units/Parameters/Policy/necromancer_policy.tres", &"applying_effects": {
 "death_curse": [-1, 10]
 
}, &"animation_index": 0, &"alternative_actions": []
 
}]
, &"effects": []
, &"base_damage": 60, &"max_hp": 150, &"armor": 0, &"evasion": 0.05, &"shielding_chance": 0.7, &"portrait_texture_path": "res://Arts/Placeholders/Archlich.jpg", &"custom_levelup_path": "", &"hero_abilities": "", &"map_effects": {
  
}, &"cost": {
 &"gold": 0, &"stone": 0, &"mana": 1700 
} 
},&"Gluttonous Serpent" : {
 &"scene_path": "res://Combat/Units/Derived units//Undead/u29_gluttonous_serpent.tscn", &"level": 3, &"large_unit": true, &"immunities": []
, &"description": "Unable to control its hunger, the Gluttonous Serpent falls into mindless feasting. Controlled only by the King\'s will, it will attack any living or otherwise creature that approaches too closely.", &"brief_description": "Large melee unit.", &"faction": 2, &"unit_type": 4, &"unit_class": 0, &"needed_xp": 900, &"attacks": [{
 &"attack_name": "Attack", &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 0, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 35, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_melee_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
  
}, &"animation_index": 0, &"alternative_actions": []
 
}]
, &"effects": [{
 &"effect_name": "Ward", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/ward.tscn", &"args": [3, 1]
 
}, {
 &"effect_name": "Devourer", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/devourer.tscn", &"args": 100 
}]
, &"base_damage": 120, &"max_hp": 600, &"armor": 20, &"evasion": 0.05, &"shielding_chance": 0.7, &"portrait_texture_path": "res://Arts/Placeholders/Gluttonous serpent.jpg", &"custom_levelup_path": "", &"hero_abilities": "", &"map_effects": {
  
}, &"cost": {
 &"gold": 300, &"stone": 1500, &"mana": 1200 
} 
},&"Zombie" : {
 &"scene_path": "res://Combat/Units/Derived units//Undead/u02_Zombie.tscn", &"level": 2, &"large_unit": false, &"immunities": [3]
, &"description": "Mindless corpses reanimated with dark magic. Zombies compensate for their disorganized nature with pure, relentless durability in battle.", &"brief_description": "Sturdy melee fighter with weak damage.", &"faction": 2, &"unit_type": 4, &"unit_class": 0, &"needed_xp": 400, &"attacks": [{
 &"attack_name": "Attack", &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 0, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 30, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_melee_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
  
}, &"animation_index": 0, &"alternative_actions": []
 
}]
, &"effects": [{
 &"effect_name": "Regeneration", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/on_turn_self_heal.tscn", &"args": 10 
}]
, &"base_damage": 35, &"max_hp": 200, &"armor": 15, &"evasion": 0.025, &"shielding_chance": 0.8, &"portrait_texture_path": "res://Arts/Placeholders/Zombie.jpg", &"custom_levelup_path": "", &"hero_abilities": "", &"map_effects": {
  
}, &"cost": {
 &"gold": 100, &"stone": 100, &"mana": 0 
} 
},&"Herald of Death" : {
 &"scene_path": "res://Combat/Units/Derived units//Undead/u18_herald_of_death.tscn", &"level": 4, &"large_unit": false, &"immunities": [3]
, &"description": "When the King sends his Heralds, fate becomes determined. They bring Death - unyielding, unmoving, imminent. There is no going back, for the Herald of Death has announced his message.", &"brief_description": "Mage with ward against physical damage.", &"faction": 2, &"unit_type": 2, &"unit_class": 5, &"needed_xp": 1600, &"attacks": [{
 &"attack_name": "Attack", &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 1, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 40, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_mage_validity.tres", &"additional_targets": "res://Combat/Units/Parameters/Additional targets/Splash.tres", &"damage_policy": "res://Combat/Units/Derived units/Undead/u18_herald_of_death.tscn::Resource_4fa37", &"applying_effects": {
 "weakness": [2, 30]
 
}, &"animation_index": 0, &"alternative_actions": []
 
}]
, &"effects": [{
 &"effect_name": "Ward", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/ward.tscn", &"args": [0, 2]
 
}]
, &"base_damage": 95, &"max_hp": 180, &"armor": 0, &"evasion": 0.05, &"shielding_chance": 0.7, &"portrait_texture_path": "res://Arts/Placeholders/Herald of death.jpg", &"custom_levelup_path": "", &"hero_abilities": "", &"map_effects": {
  
}, &"cost": {
 &"gold": 0, &"stone": 300, &"mana": 1600 
} 
},&"Dark Mage" : {
 &"scene_path": "res://Combat/Units/Derived units//Undead/u12_dark_mage.tscn", &"level": 2, &"large_unit": false, &"immunities": []
, &"description": "Sometimes death brings not peace and rest, but despair, suffering, and agony. Dark Mages focus on that aspect of death, bringing unimaginable curses upon anyone who stands in the way of the King.", &"brief_description": "Single target mage.", &"faction": 2, &"unit_type": 2, &"unit_class": 5, &"needed_xp": 400, &"attacks": [{
 &"attack_name": "Attack", &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 0, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 40, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_mage_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
 "weakness": [1, 10]
 
}, &"animation_index": 0, &"alternative_actions": []
 
}]
, &"effects": []
, &"base_damage": 45, &"max_hp": 75, &"armor": 0, &"evasion": 0.05, &"shielding_chance": 0.7, &"portrait_texture_path": "res://Arts/Placeholders/Dark mage.jpg", &"custom_levelup_path": "", &"hero_abilities": "", &"map_effects": {
  
}, &"cost": {
 &"gold": 50, &"stone": 50, &"mana": 200 
} 
},&"Wraith" : {
 &"scene_path": "res://Combat/Units/Derived units//Undead/u15_wraith.tscn", &"level": 3, &"large_unit": false, &"immunities": [3]
, &"description": "Those who delve too deep into the arts of dark magic eventually fall into the abyss. The King of Necropolis returns them, not as people, but as vengeful spirits - wraiths. Consumed by their desire to harvest suffering, these souls are morphed into horrifying creatures.", &"brief_description": "Mage with ward against physical damage.", &"faction": 2, &"unit_type": 2, &"unit_class": 5, &"needed_xp": 900, &"attacks": [{
 &"attack_name": "Attack", &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 1, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 40, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_mage_validity.tres", &"additional_targets": "res://Combat/Units/Parameters/Additional targets/Splash.tres", &"damage_policy": "res://Combat/Units/Derived units/Undead/u15_wraith.tscn::Resource_uj6co", &"applying_effects": {
 "weakness": [1, 10]
 
}, &"animation_index": 0, &"alternative_actions": []
 
}]
, &"effects": [{
 &"effect_name": "Ward", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/ward.tscn", &"args": [0, 1]
 
}]
, &"base_damage": 60, &"max_hp": 100, &"armor": 0, &"evasion": 0.05, &"shielding_chance": 0.7, &"portrait_texture_path": "res://Arts/Placeholders/Wraith.jpg", &"custom_levelup_path": "", &"hero_abilities": "", &"map_effects": {
  
}, &"cost": {
 &"gold": 0, &"stone": 0, &"mana": 1200 
} 
},&"Skeleton warrior" : {
 &"scene_path": "res://Combat/Units/Derived units//Undead/u07_skeleton_warrior.tscn", &"level": 4, &"large_unit": false, &"immunities": []
, &"description": "Restless in death are those whose souls, too attached to worldly treasures, are barred from The Dark. The Necropolis grants these spirits a home and a chance to find worth in death. Their payment is eternal service as the King\'s Skeleton Warriors.", &"brief_description": "Melee fighter that rises stronger every time it\'s resurrected.", &"faction": 2, &"unit_type": 4, &"unit_class": 0, &"needed_xp": 1600, &"attacks": [{
 &"attack_name": "Attack", &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 0, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 40, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_melee_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
  
}, &"animation_index": 0, &"alternative_actions": []
 
}]
, &"effects": [{
 &"effect_name": "Crafted body", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/crafted_body.tscn", &"args": {
 &"armor": 15, &"base_damage": 30, &"evasion": 0.015, &"max_HP": 50 
} 
}, {
 &"effect_name": "Crypt spirit", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/on_death_summon.tscn", &"args": ["res://Combat/Units/Derived units/Undead/u05_skeleton.tscn", {
 "reanimation": {
 &"armor": 5, &"base_damage": 10, &"evasion": 0.005, &"max_HP": 15 
} 
}]
 
}]
, &"base_damage": 80, &"max_hp": 275, &"armor": 35, &"evasion": 0.05, &"shielding_chance": 0.0, &"portrait_texture_path": "res://Arts/Placeholders/Skeleton champion.jpg", &"custom_levelup_path": "", &"hero_abilities": "", &"map_effects": {
  
}, &"cost": {
 &"gold": 200, &"stone": 1000, &"mana": 350 
} 
},&"Phantom Warrior" : {
 &"scene_path": "res://Combat/Units/Derived units//Undead/u04_phantom_warrior.tscn", &"level": 3, &"large_unit": false, &"immunities": [3]
, &"description": "When an enemy seems too strong to confront directly, necromancers create Phantom Warriors. Their spectral nature makes them invulnerable to physical attacks - perfect for facing troops that rely on brute force.", &"brief_description": "Melee fighter immune to physical damage for limited time.", &"faction": 2, &"unit_type": 4, &"unit_class": 0, &"needed_xp": 900, &"attacks": [{
 &"attack_name": "Attack", &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 2, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 40, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/melee_with_self.tres", &"additional_targets": "", &"damage_policy": "res://Combat/Units/Parameters/Policy/phantom_warrior_policy.tres", &"applying_effects": {
  
}, &"animation_index": 0, &"alternative_actions": []
 
}]
, &"effects": [{
 &"effect_name": "Illusive", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/illusive.tscn", &"args": {
 &"evasion_buff": 0.03, &"other_stat_buff": "Attack", &"other_stat_buff_strength": 10, &"other_stat_buff_multiplier": 1.0 
} 
}, {
 &"effect_name": "Phantom", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/Phantom.tscn", &"args": [0, 1]
 
}]
, &"base_damage": 45, &"max_hp": 180, &"armor": 10, &"evasion": 0.1, &"shielding_chance": 0.7, &"portrait_texture_path": "res://Arts/Placeholders/Skeleton hero.jpg", &"custom_levelup_path": "", &"hero_abilities": "", &"map_effects": {
  
}, &"cost": {
 &"gold": 100, &"stone": 300, &"mana": 300 
} 
},&"The Eternal" : {
 &"scene_path": "res://Combat/Units/Derived units//Undead/u25_the_eternal.tscn", &"level": 4, &"large_unit": false, &"immunities": [1]
, &"description": "The eternal abyss watches your every move. None can go unnoticed, and none shall escape. Glimpse into the void and lose yourself, for that is the desire of The Eternal.", &"brief_description": "Mage with low damage but significant debuff.", &"faction": 2, &"unit_type": 3, &"unit_class": 5, &"needed_xp": 1600, &"attacks": [{
 &"attack_name": "Attack", &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 1, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 35, &"evadable": true, &"tags": [&"shot"]
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_archer_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
 "burn": [1, 25]
, "confused": [3, 0.65]
 
}, &"animation_index": 0, &"alternative_actions": []
 
}]
, &"effects": []
, &"base_damage": 40, &"max_hp": 180, &"armor": 0, &"evasion": 0.2, &"shielding_chance": 0.7, &"portrait_texture_path": "res://Arts/Placeholders/The eternal.jpg", &"custom_levelup_path": "", &"hero_abilities": "", &"map_effects": {
  
}, &"cost": {
 &"gold": 0, &"stone": 0, &"mana": 1666 
} 
},&"Templar" : {
 &"scene_path": "res://Combat/Units/Derived units//Undead/u03_Templar.tscn", &"level": 2, &"large_unit": false, &"immunities": []
, &"description": "Mocking the Holy Church, the King of Necropolis created his own order of Templars. Its members gain powers ovet the elements and authority, serving the Necropolis not as mindless thralls, but as willing champions of its dark purpose.", &"brief_description": "Living warrior with ward against elemental damage.", &"faction": 2, &"unit_type": 4, &"unit_class": 0, &"needed_xp": 400, &"attacks": [{
 &"attack_name": "Attack", &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 0, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 40, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_melee_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
  
}, &"animation_index": 0, &"alternative_actions": []
 
}]
, &"effects": [{
 &"effect_name": "Ward", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/ward.tscn", &"args": [1, 1]
 
}, {
 &"effect_name": "Twisted will", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/random_retaliation_on_debuff.tscn", &"args": [2, 0, 1.2]
 
}]
, &"base_damage": 45, &"max_hp": 150, &"armor": 10, &"evasion": 0.05, &"shielding_chance": 0.75, &"portrait_texture_path": "res://Arts/Placeholders/Templar.jpg", &"custom_levelup_path": "", &"hero_abilities": "", &"map_effects": {
  
}, &"cost": {
 &"gold": 450, &"stone": 100, &"mana": 0 
} 
},&"Death Acolyte" : {
 &"scene_path": "res://Combat/Units/Derived units//Undead/u10_acolyte.tscn", &"level": 1, &"large_unit": false, &"immunities": []
, &"description": "Mortals who bear the stigma of studying forbidden death magic are not welcome in normal society. While not yet citizens of the Necropolis, they often ally with its forces in the wilds, aiding the King\'s aims in hopes of one day earning a place within.", &"brief_description": "Weak mage.", &"faction": 2, &"unit_type": 2, &"unit_class": 5, &"needed_xp": 150, &"attacks": [{
 &"attack_name": "Attack", &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 1, &"accuracy": 0.9, &"targets_needed": 1, &"initiative": 35, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_archer_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
  
}, &"animation_index": 0, &"alternative_actions": []
 
}]
, &"effects": []
, &"base_damage": 15, &"max_hp": 50, &"armor": 0, &"evasion": 0.045, &"shielding_chance": 0.7, &"portrait_texture_path": "res://Arts/Placeholders/Death acolyte.jpg", &"custom_levelup_path": "", &"hero_abilities": "", &"map_effects": {
  
}, &"cost": {
 &"gold": 30, &"stone": 0, &"mana": 30 
} 
},&"The Devourer" : {
 &"scene_path": "res://Combat/Units/Derived units//Undead/u31_the_devourer.tscn", &"level": 4, &"large_unit": true, &"immunities": []
, &"description": "A monstrous, snake-like creature bloated with the power of countless consumed souls, the Devourer hunts the living. No single creature can escape its cunning fangs once it decides to feast upon their body and spirit.", &"brief_description": "Large melee unit.", &"faction": 2, &"unit_type": 4, &"unit_class": 0, &"needed_xp": 1600, &"attacks": [{
 &"attack_name": "Attack", &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 0, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 40, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_melee_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
  
}, &"animation_index": 0, &"alternative_actions": []
 
}]
, &"effects": [{
 &"effect_name": "Devourer", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/devourer.tscn", &"args": 200 
}, {
 &"effect_name": "Ward", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/ward.tscn", &"args": [3, 1]
 
}, {
 &"effect_name": "Agility", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/agility.tscn", &"args": [3, 1.3]
 
}]
, &"base_damage": 240, &"max_hp": 800, &"armor": 35, &"evasion": 0.1, &"shielding_chance": 0.7, &"portrait_texture_path": "res://Arts/Placeholders/Devourer.jpg", &"custom_levelup_path": "", &"hero_abilities": "", &"map_effects": {
  
}, &"cost": {
 &"gold": 500, &"stone": 4000, &"mana": 2100 
} 
},&"Dreadwyrm" : {
 &"scene_path": "res://Combat/Units/Derived units//Undead/u30_dreadwyrm.tscn", &"level": 3, &"large_unit": true, &"immunities": []
, &"description": "Terrifying Dreadwyrms are often confused with true dragons: their necrotic breath can cover entire cities, leaving only lifeless wastelands", &"brief_description": "Large unit, can attack entire line.", &"faction": 2, &"unit_type": 1, &"unit_class": 5, &"needed_xp": 900, &"attacks": [{
 &"attack_name": "Attack", &"damage_multiplier": 0.5, &"damage_override": false, &"is_heal": false, &"type": 1, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 35, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_archer_validity.tres", &"additional_targets": "res://Combat/Units/Parameters/Additional targets/entire_line.tres", &"damage_policy": "", &"applying_effects": {
  
}, &"animation_index": 0, &"alternative_actions": []
 
}]
, &"effects": [{
 &"effect_name": "Ward", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/ward.tscn", &"args": [3, 1]
 
}]
, &"base_damage": 90, &"max_hp": 600, &"armor": 20, &"evasion": 0.005, &"shielding_chance": 0.7, &"portrait_texture_path": "res://Arts/Placeholders/Dreadwyrm.jpg", &"custom_levelup_path": "", &"hero_abilities": "", &"map_effects": {
  
}, &"cost": {
 &"gold": 500, &"stone": 2300, &"mana": 1800 
} 
},&"Dracolich" : {
 &"scene_path": "res://Combat/Units/Derived units//Undead/u33_Dracolich.tscn", &"level": 5, &"large_unit": true, &"immunities": [3]
, &"description": "\"... Never have we ever seen a creature so magnificent and yet so terrifying. Its wings are nothing but bones with lumps of dead flesh, its head is a deformed skull, and an arcane power that broke our greatest wards like glass ...\"\n\"Survivor\'s diary\", by Elara Pustolik", &"brief_description": "Large unit, can attack any target.", &"faction": 2, &"unit_type": 1, &"unit_class": 5, &"needed_xp": 2500, &"attacks": [{
 &"attack_name": "Attack", &"damage_multiplier": 0.8, &"damage_override": false, &"is_heal": false, &"type": 1, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 35, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_archer_validity.tres", &"additional_targets": "res://Combat/Units/Parameters/Additional targets/entire_line.tres", &"damage_policy": "res://Combat/Units/Parameters/Policy/decay_policy.tres", &"applying_effects": {
 "death_curse": [-1, 10]
, "only_to_type": [2, "weakness", [3, 35]
]
 
}, &"animation_index": 0, &"alternative_actions": []
 
}]
, &"effects": []
, &"base_damage": 200, &"max_hp": 1000, &"armor": 50, &"evasion": 0.01, &"shielding_chance": 0.7, &"portrait_texture_path": "res://Arts/Placeholders/Dracolich.jpg", &"custom_levelup_path": "", &"hero_abilities": "", &"map_effects": {
  
}, &"cost": {
 &"gold": 400, &"stone": 6500, &"mana": 4500 
} 
},&"Skeleton" : {
 &"scene_path": "res://Combat/Units/Derived units//Undead/u05_skeleton.tscn", &"level": 3, &"large_unit": false, &"immunities": [3]
, &"description": "Reanimating mindless husks is useful for creating a workforce, but the true power of a necromancer is shown when they force bodies devoid of flesh to rise from the dead. Skeleton reanimation is not an easy skill to master, but the Necropolis cannot build a meaningful army without these creatures. Unfamiliar with tiredness, they will pursue any target their masters command.", &"brief_description": "Weak melee fighter that rises stronger every time it\'s resurrected.", &"faction": 2, &"unit_type": 4, &"unit_class": 0, &"needed_xp": 900, &"attacks": [{
 &"attack_name": "Attack", &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 0, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 40, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_melee_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
  
}, &"animation_index": 0, &"alternative_actions": []
 
}]
, &"effects": [{
 &"effect_name": "Crafted body", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/crafted_body.tscn", &"args": {
 &"max_HP": 30, &"armor": 10, &"base_damage": 20, &"evasion": 0.01 
} 
}]
, &"base_damage": 60, &"max_hp": 200, &"armor": 20, &"evasion": 0.05, &"shielding_chance": 0.0, &"portrait_texture_path": "res://Arts/Placeholders/Skeleton.jpg", &"custom_levelup_path": "", &"hero_abilities": "", &"map_effects": {
  
}, &"cost": {
 &"gold": 150, &"stone": 600, &"mana": 300 
} 
},&"Undying Nighthunter" : {
 &"scene_path": "res://Combat/Units/Derived units//Undead/u32_undying_nighthunter.tscn", &"level": 4, &"large_unit": true, &"immunities": []
, &"description": "Dragons defiled by the King\'s power and granted eternal life become his servants—the Undying Nighthunters. Vanishing into the nocturnal darkness, these creatures will let no one pass the Necropolis borders.", &"brief_description": "Large unit, can attack entire line.", &"faction": 2, &"unit_type": 1, &"unit_class": 5, &"needed_xp": 1600, &"attacks": [{
 &"attack_name": "Attack", &"damage_multiplier": 0.7, &"damage_override": false, &"is_heal": false, &"type": 1, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 35, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_archer_validity.tres", &"additional_targets": "res://Combat/Units/Parameters/Additional targets/entire_line.tres", &"damage_policy": "res://Combat/Units/Parameters/Policy/decay_policy.tres", &"applying_effects": {
 "only_to_type": [2, "weakness", [3, 35]
]
 
}, &"animation_index": 0, &"alternative_actions": []
 
}]
, &"effects": [{
 &"effect_name": "Ward", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/ward.tscn", &"args": [3, 2]
 
}]
, &"base_damage": 180, &"max_hp": 800, &"armor": 35, &"evasion": 0.005, &"shielding_chance": 0.7, &"portrait_texture_path": "res://Arts/Placeholders/Undying nighthunter.jpg", &"custom_levelup_path": "", &"hero_abilities": "", &"map_effects": {
  
}, &"cost": {
 &"gold": 400, &"stone": 4300, &"mana": 2500 
} 
},&"Ghost" : {
 &"scene_path": "res://Combat/Units/Derived units//Undead/u21_ghost.tscn", &"level": 1, &"large_unit": false, &"immunities": [3]
, &"description": "When a soul cannot find its way to The Dark, it may be materialized as a ghost. Though unable to interfere directly, these creatures trap unsuspecting victims in illusions, rendering them vulnerable to other Necropolis forces.", &"brief_description": "Archer with no damage that pralyses targets.", &"faction": 2, &"unit_type": 3, &"unit_class": 4, &"needed_xp": 1, &"attacks": [{
 &"attack_name": "Attack", &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 2, &"accuracy": 0.65, &"targets_needed": 1, &"initiative": 25, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_archer_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
 "paralysis": [1.0, 1]
 
}, &"animation_index": 0, &"alternative_actions": []
 
}]
, &"effects": []
, &"base_damage": 0, &"max_hp": 70, &"armor": 0, &"evasion": 0.07, &"shielding_chance": 0.7, &"portrait_texture_path": "res://Arts/Placeholders/Ghost.jpg", &"custom_levelup_path": "", &"hero_abilities": "", &"map_effects": {
  
}, &"cost": {
 &"gold": 0, &"stone": 0, &"mana": 50 
} 
},&"Vampire" : {
 &"scene_path": "res://Combat/Units/Derived units//Undead/u13_vampire.tscn", &"level": 3, &"large_unit": false, &"immunities": []
, &"description": "Very few mortals dare to perform the blood ritual and become the hunters of the night - Vampires. These creatures are neither dead nor alive. Straddling the border between life and death, they sustain their accursed existence only by consuming the life force of others can.", &"brief_description": "Mage with lifesteal.", &"faction": 2, &"unit_type": 2, &"unit_class": 4, &"needed_xp": 900, &"attacks": [{
 &"attack_name": "Attack", &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 3, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 40, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_archer_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
  
}, &"animation_index": 0, &"alternative_actions": []
 
}]
, &"effects": [{
 &"effect_name": "Vampirism", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/vampirism.tscn", &"args": [0.4, true]
 
}, {
 &"effect_name": "Ward", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/ward.tscn", &"args": [3, 1]
 
}]
, &"base_damage": 40, &"max_hp": 150, &"armor": 0, &"evasion": 0.05, &"shielding_chance": 0.7, &"portrait_texture_path": "res://Arts/Placeholders/Vampire.jpg", &"custom_levelup_path": "", &"hero_abilities": "", &"map_effects": {
  
}, &"cost": {
 &"gold": 200, &"stone": 500, &"mana": 700 
} 
},&"Skeleton Hero" : {
 &"scene_path": "res://Combat/Units/Derived units//Undead/u09_skeleton_hero.tscn", &"level": 5, &"large_unit": false, &"immunities": []
, &"description": "The most powerful of the undead troops are called Skeleton Heroes. Cursing the very land they walk on, these creatures are able to defy the laws of nature to impose their Master\'s will and spread the Necropolis\'s domain.", &"brief_description": "Melee fighter that rises stronger every time it\'s resurrected.", &"faction": 2, &"unit_type": 4, &"unit_class": 0, &"needed_xp": 2500, &"attacks": [{
 &"attack_name": "Attack", &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 0, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 40, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_melee_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
  
}, &"animation_index": 0, &"alternative_actions": []
 
}]
, &"effects": [{
 &"effect_name": "Crafted body", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/crafted_body.tscn", &"args": {
 &"armor": 20, &"base_damage": 30, &"evasion": 0.02, &"max_HP": 70 
} 
}, {
 &"effect_name": "Grave caress", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/vampirism.tscn", &"args": [20.0, false]
 
}, {
 &"effect_name": "Crypt spirit", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/on_death_summon.tscn", &"args": ["res://Combat/Units/Derived units/Undead/u05_skeleton.tscn", {
 "reanimation": {
 &"armor": 5, &"base_damage": 10, &"evasion": 0.005, &"max_HP": 15 
} 
}]
 
}]
, &"base_damage": 100, &"max_hp": 350, &"armor": 50, &"evasion": 0.05, &"shielding_chance": 0.3, &"portrait_texture_path": "res://Arts/Placeholders/Phantom warrior.jpg", &"custom_levelup_path": "", &"hero_abilities": "", &"map_effects": {
  
}, &"cost": {
 &"gold": 200, &"stone": 1000, &"mana": 500 
} 
},&"Wyvern" : {
 &"scene_path": "res://Combat/Units/Derived units//Undead/u27_wyvern.tscn", &"level": 1, &"large_unit": true, &"immunities": []
, &"description": "Wyverns are the earthbound cousins of dragons, stripped of the freedom of flight. Their bitterness over this difference drives them to seek power, often turning to the King of Necropolis.", &"brief_description": "Large unit, single target archer.", &"faction": 2, &"unit_type": 1, &"unit_class": 1, &"needed_xp": 380, &"attacks": [{
 &"attack_name": "Attack", &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 1, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 35, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_archer_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
  
}, &"animation_index": 0, &"alternative_actions": []
 
}]
, &"effects": []
, &"base_damage": 50, &"max_hp": 300, &"armor": 0, &"evasion": 0.005, &"shielding_chance": 0.7, &"portrait_texture_path": "res://Arts/Placeholders/Wyvern.jpg", &"custom_levelup_path": "", &"hero_abilities": "", &"map_effects": {
  
}, &"cost": {
 &"gold": 100, &"stone": 400, &"mana": 100 
} 
},&"Necromancer" : {
 &"scene_path": "res://Combat/Units/Derived units//Undead/u11_necromancer.tscn", &"level": 2, &"large_unit": false, &"immunities": []
, &"description": "When a mortal gazes into the essence of life, they discover that death does not dictate the end of one\'s being. Those who can manipulate this knowledge to revive a body are called Necromancers.", &"brief_description": "Weak mage with ability to resurrect.", &"faction": 2, &"unit_type": 2, &"unit_class": 5, &"needed_xp": 400, &"attacks": [{
 &"attack_name": "Attack", &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 0, &"accuracy": 0.85, &"targets_needed": 1, &"initiative": 30, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/necromancer_validity.tres", &"additional_targets": "", &"damage_policy": "res://Combat/Units/Derived units/Undead/u11_necromancer.tscn::Resource_0m3ru", &"applying_effects": {
  
}, &"animation_index": 0, &"alternative_actions": []
 
}]
, &"effects": []
, &"base_damage": 30, &"max_hp": 75, &"armor": 0, &"evasion": 0.05, &"shielding_chance": 0.7, &"portrait_texture_path": "res://Arts/Placeholders/Necromancer.jpg", &"custom_levelup_path": "", &"hero_abilities": "", &"map_effects": {
  
}, &"cost": {
 &"gold": 50, &"stone": 0, &"mana": 150 
} 
},&"Blood spawn" : {
 &"scene_path": "res://Combat/Units/Derived units//Undead/u19_blood_spawn.tscn", &"level": 5, &"large_unit": false, &"immunities": []
, &"description": "Vampires who succumb to their insatiable hunger mutate beyond recognition. These Blood Spawn are devoid of any intelligence they once had and care only about killing and devouring as much of the living as possible. Mindless piles of flesh and bone, they are equally dangerous to allies and foes alike.\t", &"brief_description": "Strong melee unit.", &"faction": 2, &"unit_type": 4, &"unit_class": 0, &"needed_xp": 2500, &"attacks": [{
 &"attack_name": "Attack", &"damage_multiplier": 0.5, &"damage_override": false, &"is_heal": false, &"type": 0, &"accuracy": 0.95, &"targets_needed": 2, &"initiative": 40, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_melee_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
  
}, &"animation_index": 0, &"alternative_actions": []
 
}]
, &"effects": [{
 &"effect_name": "Vampirism", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/vampirism.tscn", &"args": [0.5, true]
 
}, {
 &"effect_name": "Fear aura", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/fear_aura.tscn", &"args": 0.05 
}, {
 &"effect_name": "Ward", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/ward.tscn", &"args": [3, 2]
 
}]
, &"base_damage": 100, &"max_hp": 350, &"armor": 50, &"evasion": 0.1, &"shielding_chance": 0.7, &"portrait_texture_path": "res://Arts/Placeholders/Blood spawn.jpg", &"custom_levelup_path": "", &"hero_abilities": "", &"map_effects": {
  
}, &"cost": {
 &"gold": 0, &"stone": 1000, &"mana": 1000 
} 
},&"Vision of Darkness" : {
 &"scene_path": "res://Combat/Units/Derived units//Undead/u26_vision_of_darkness.tscn", &"level": 4, &"large_unit": false, &"immunities": [3]
, &"description": "A quick glance into the darkness that awaits every soul at the end makes even the bravest tremble in fear.", &"brief_description": "Archer with almost no damage that pralyses several targets.", &"faction": 2, &"unit_type": 1, &"unit_class": 0, &"needed_xp": 1600, &"attacks": [{
 &"attack_name": "Attack", &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 0, &"accuracy": 0.685, &"targets_needed": 1, &"initiative": 25, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_archer_validity.tres", &"additional_targets": "res://Combat/Units/Parameters/Additional targets/Splash.tres", &"damage_policy": "", &"applying_effects": {
 "paralysis": [0.9, 1]
 
}, &"animation_index": 0, &"alternative_actions": []
 
}]
, &"effects": []
, &"base_damage": 25, &"max_hp": 150, &"armor": 0, &"evasion": 0.2, &"shielding_chance": 0.7, &"portrait_texture_path": "res://Arts/Placeholders/Vision of darkness.jpg", &"custom_levelup_path": "", &"hero_abilities": "", &"map_effects": {
  
}, &"cost": {
 &"gold": 0, &"stone": 0, &"mana": 2000 
} 
},&"Doomdrake" : {
 &"scene_path": "res://Combat/Units/Derived units//Undead/u28_doomdrake.tscn", &"level": 2, &"large_unit": true, &"immunities": []
, &"description": "When a wyvern consumes enough bodies on the battlefield, it grows larger and more grotesque, transforming into a Doomdrake. Its breath is poisonous and its flesh is rotten, defiling the living creature it once was.", &"brief_description": "Large unit, single target archer.", &"faction": 2, &"unit_type": 1, &"unit_class": 1, &"needed_xp": 400, &"attacks": [{
 &"attack_name": "Attack", &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 0, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 35, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_archer_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
 "Poison": [20, 2]
 
}, &"animation_index": 0, &"alternative_actions": []
 
}]
, &"effects": [{
 &"effect_name": "Ward", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/ward.tscn", &"args": [3, 1]
 
}]
, &"base_damage": 65, &"max_hp": 450, &"armor": 10, &"evasion": 0.005, &"shielding_chance": 0.7, &"portrait_texture_path": "res://Arts/Placeholders/Doomdrake.jpg", &"custom_levelup_path": "", &"hero_abilities": "", &"map_effects": {
  
}, &"cost": {
 &"gold": 200, &"stone": 700, &"mana": 300 
} 
},&"Vampire Lord" : {
 &"scene_path": "res://Combat/Units/Derived units//Undead/u20_vampire_lord.tscn", &"level": 5, &"large_unit": false, &"immunities": []
, &"description": "Untouched by time, Vampire Lords hone their magic eternally, growing ever stronger in power.", &"brief_description": "Mage with lifesteal.", &"faction": 2, &"unit_type": 2, &"unit_class": 4, &"needed_xp": 1700, &"attacks": [{
 &"attack_name": "Attack", &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 3, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 45, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_archer_validity.tres", &"additional_targets": "res://Combat/Units/Parameters/Additional targets/Splash.tres", &"damage_policy": "res://Combat/Units/Derived units/Undead/u20_vampire_lord.tscn::Resource_n62fs", &"applying_effects": {
 "clumsiness": [0.05, 2]
, "vulnerability": [3, 10]
 
}, &"animation_index": 0, &"alternative_actions": [{
 &"attack_name": "Disappear", &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 2, &"accuracy": 1.0, &"targets_needed": 1, &"initiative": 0, &"evadable": false, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/any_unit.tres", &"additional_targets": "", &"damage_policy": "res://Combat/Units/Parameters/Policy/disappear_policy.tres", &"applying_effects": {
  
}, &"animation_index": 0, &"alternative_actions": []
 
}]
 
}]
, &"effects": [{
 &"effect_name": "Vampirism", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/vampirism.tscn", &"args": [0.65, true]
 
}, {
 &"effect_name": "Ward", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/ward.tscn", &"args": [3, 2]
 
}]
, &"base_damage": 75, &"max_hp": 285, &"armor": 0, &"evasion": 0.05, &"shielding_chance": 0.7, &"portrait_texture_path": "res://Arts/Placeholders/Vampire lord (2).jpg", &"custom_levelup_path": "", &"hero_abilities": "", &"map_effects": {
  
}, &"cost": {
 &"gold": 500, &"stone": 700, &"mana": 1100 
} 
},&"Destined" : {
 &"scene_path": "res://Combat/Units/Derived units//Undead/u01_destined.tscn", &"level": 1, &"large_unit": false, &"immunities": []
, &"description": "The King of Necropolis accepts all servants. Those who pledge their loyalty to the Necropolis before death claims them are known as the Destined. They are often lured by the King\'s promises, unaware of the fate that awaits them.", &"brief_description": "Regular melee fighter.", &"faction": 2, &"unit_type": 4, &"unit_class": 0, &"needed_xp": 150, &"attacks": [{
 &"attack_name": "Attack", &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 0, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 40, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_melee_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
  
}, &"animation_index": 0, &"alternative_actions": []
 
}]
, &"effects": []
, &"base_damage": 35, &"max_hp": 90, &"armor": 0, &"evasion": 0.04, &"shielding_chance": 0.7, &"portrait_texture_path": "res://Arts/Placeholders/Destined.jpg", &"custom_levelup_path": "", &"hero_abilities": "", &"map_effects": {
  
}, &"cost": {
 &"gold": 30, &"stone": 40, &"mana": 0 
} 
},&"Shadow" : {
 &"scene_path": "res://Combat/Units/Derived units//Undead/u24_shadow.tscn", &"level": 3, &"large_unit": false, &"immunities": [3]
, &"description": "The King\'s presence is in everything, following every living soul, for he knows everyone will bow to him one day. Flee if you can, tiny mortal, for your very shadow has turned against you.", &"brief_description": "Archer with almost no damage that pralyses several targets.", &"faction": 2, &"unit_type": 1, &"unit_class": 4, &"needed_xp": 900, &"attacks": [{
 &"attack_name": "Attack", &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 0, &"accuracy": 0.65, &"targets_needed": 1, &"initiative": 25, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_archer_validity.tres", &"additional_targets": "res://Combat/Units/Parameters/Additional targets/Splash.tres", &"damage_policy": "", &"applying_effects": {
 "paralysis": [0.9, 2]
 
}, &"animation_index": 0, &"alternative_actions": []
 
}]
, &"effects": []
, &"base_damage": 15, &"max_hp": 11, &"armor": 0, &"evasion": 0.15, &"shielding_chance": 0.7, &"portrait_texture_path": "res://Arts/Placeholders/Shadow.jpg", &"custom_levelup_path": "", &"hero_abilities": "", &"map_effects": {
  
}, &"cost": {
 &"gold": 0, &"stone": 0, &"mana": 380 
} 
},&"Dark Lord" : {
 &"scene_path": "res://Combat/Units/Derived units//Undead/u08_dark_lord.tscn", &"level": 4, &"large_unit": false, &"immunities": [1]
, &"description": "The living who have proven their worth to the Necropolis are granted access to the secrets of the undead. They bear the name of Dark Lord, for their connection to the Necropolis is so strong that their whisper can deprive others of the will to live.", &"brief_description": "Melee anti-mage fighters.", &"faction": 2, &"unit_type": 4, &"unit_class": 0, &"needed_xp": 1600, &"attacks": [{
 &"attack_name": "Attack", &"damage_multiplier": 0.65, &"damage_override": false, &"is_heal": false, &"type": 1, &"accuracy": 0.95, &"targets_needed": 2, &"initiative": 40, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_melee_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
 "silence": 1 
}, &"animation_index": 0, &"alternative_actions": []
 
}]
, &"effects": [{
 &"effect_name": "Twisted will", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/random_retaliation_on_debuff.tscn", &"args": [-1, 0, 1.3]
 
}, {
 &"effect_name": "Denial", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/negative_effect_negate.tscn", &"args": 3 
}]
, &"base_damage": 80, &"max_hp": 275, &"armor": 35, &"evasion": 0.05, &"shielding_chance": 0.7, &"portrait_texture_path": "res://Arts/Placeholders/Dark lord.jpg", &"custom_levelup_path": "", &"hero_abilities": "", &"map_effects": {
  
}, &"cost": {
 &"gold": 1200, &"stone": 200, &"mana": 0 
} 
},&"Lich" : {
 &"scene_path": "res://Combat/Units/Derived units//Undead/u14_lich.tscn", &"level": 3, &"large_unit": false, &"immunities": [3]
, &"description": "When a necromancer willingly parts with their life in the name of the Necropolis, they are bestowed a place among the elite. They are now a Lich - a conduit of eternal rest for all who oppose the will of the King.", &"brief_description": "Weak mage with ability to resurrect and two actions per round.", &"faction": 2, &"unit_type": 2, &"unit_class": 5, &"needed_xp": 900, &"attacks": [{
 &"attack_name": "Attack", &"damage_multiplier": 0.6, &"damage_override": false, &"is_heal": false, &"type": 1, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 30, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/necromancer_validity.tres", &"additional_targets": "", &"damage_policy": "res://Combat/Units/Derived units/Undead/u14_lich.tscn::Resource_4gd0u", &"applying_effects": {
 "death_curse": [-1, 7]
 
}, &"animation_index": 0, &"alternative_actions": []
 
}, {
 &"attack_name": "Attack", &"damage_multiplier": 0.4, &"damage_override": false, &"is_heal": false, &"type": 1, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 25, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/necromancer_validity.tres", &"additional_targets": "", &"damage_policy": "res://Combat/Units/Derived units/Undead/u14_lich.tscn::Resource_4gd0u", &"applying_effects": {
 "death_curse": [-1, 7]
 
}, &"animation_index": 0, &"alternative_actions": []
 
}]
, &"effects": []
, &"base_damage": 40, &"max_hp": 85, &"armor": 0, &"evasion": 0.05, &"shielding_chance": 0.7, &"portrait_texture_path": "res://Arts/Placeholders/Lich.jpg", &"custom_levelup_path": "", &"hero_abilities": "", &"map_effects": {
  
}, &"cost": {
 &"gold": 0, &"stone": 300, &"mana": 900 
} 
},&"Elder vampire" : {
 &"scene_path": "res://Combat/Units/Derived units//Undead/u16_elder_vampire.tscn", &"level": 4, &"large_unit": false, &"immunities": []
, &"description": "Ancient beings driven by bloodlust, Elder Vampires command the very essence of life and will consume the entire being of anyone foolish enough to wander the wilds at night.", &"brief_description": "Mage with lifesteal.", &"faction": 2, &"unit_type": 2, &"unit_class": 4, &"needed_xp": 1600, &"attacks": [{
 &"attack_name": "Attack", &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 3, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 40, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_mage_validity.tres", &"additional_targets": "res://Combat/Units/Parameters/Additional targets/Splash.tres", &"damage_policy": "res://Combat/Units/Derived units/Undead/u16_elder_vampire.tscn::Resource_5sbny", &"applying_effects": {
 "clumsiness": [0.05, 2]
 
}, &"animation_index": 0, &"alternative_actions": []
 
}]
, &"effects": [{
 &"effect_name": "Vampirism", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/vampirism.tscn", &"args": [0.6, true]
 
}, {
 &"effect_name": "Ward", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/ward.tscn", &"args": [3, 1]
 
}]
, &"base_damage": 60, &"max_hp": 220, &"armor": 0, &"evasion": 0.05, &"shielding_chance": 0.7, &"portrait_texture_path": "res://Arts/Placeholders/Vampire lord.jpg", &"custom_levelup_path": "", &"hero_abilities": "", &"map_effects": {
  
}, &"cost": {
 &"gold": 200, &"stone": 600, &"mana": 1000 
} 
},&"Fallen Inquisitor" : {
 &"scene_path": "res://Combat/Units/Derived units//Undead/u06_fallen_inquisitor.tscn", &"level": 3, &"large_unit": false, &"immunities": []
, &"description": "Inquisitors who doubt the Church\'s ways are branded heretics. To these outcasts, the King of Necropolis extends an invitation to his city. Those who accept his offer become Fallen Inquisitors, whom the Necropolis prizes far more than their former masters ever did - even in their living state.", &"brief_description": "Melee fighter, strong against debuffs.", &"faction": 2, &"unit_type": 4, &"unit_class": 0, &"needed_xp": 900, &"attacks": [{
 &"attack_name": "Attack", &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 1, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 40, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_melee_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
 "silence": 0 
}, &"animation_index": 0, &"alternative_actions": []
 
}]
, &"effects": [{
 &"effect_name": "Ward", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/ward.tscn", &"args": [1, 1]
 
}, {
 &"effect_name": "Twisted will", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/random_retaliation_on_debuff.tscn", &"args": [4, 0, 1.25]
 
}, {
 &"effect_name": "Denial", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/negative_effect_negate.tscn", &"args": 1 
}]
, &"base_damage": 60, &"max_hp": 200, &"armor": 20, &"evasion": 0.05, &"shielding_chance": 0.7, &"portrait_texture_path": "res://Arts/Placeholders/Fallen inquisitor.jpg", &"custom_levelup_path": "", &"hero_abilities": "", &"map_effects": {
  
}, &"cost": {
 &"gold": 600, &"stone": 150, &"mana": 0 
} 
},&"Specter" : {
 &"scene_path": "res://Combat/Units/Derived units//Undead/u22_specter.tscn", &"level": 2, &"large_unit": false, &"immunities": [3]
, &"description": "Souls bound to this realm against their will, Specters crave vengeance upon every living being, manifesting in nightmares and attacking the sanity of the weak-minded.", &"brief_description": "Archer with almost no damage that pralyses targets.", &"faction": 2, &"unit_type": 3, &"unit_class": 4, &"needed_xp": 400, &"attacks": [{
 &"attack_name": "Attack", &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 2, &"accuracy": 0.75, &"targets_needed": 1, &"initiative": 25, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_archer_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
 "paralysis": [0.7, 1]
 
}, &"animation_index": 0, &"alternative_actions": []
 
}]
, &"effects": []
, &"base_damage": 10, &"max_hp": 100, &"armor": 0, &"evasion": 0.1, &"shielding_chance": 0.7, &"portrait_texture_path": "res://Arts/Placeholders/Specter.jpg", &"custom_levelup_path": "", &"hero_abilities": "", &"map_effects": {
  
}, &"cost": {
 &"gold": 0, &"stone": 0, &"mana": 180 
} 
},&"Will-o’-Wisp" : {
 &"scene_path": "res://Combat/Units/Derived units//Undead/u23_will_o_wisp.tscn", &"level": 3, &"large_unit": false, &"immunities": [1]
, &"description": "Flickering lights above the bog, Will-o’-Wisps lure travelers in only to drain them of their willpower. They serve no one, but the King\'s promise of new, delicious mortals makes them join the undead march.", &"brief_description": "Mage with low damage but significant debuff.", &"faction": 2, &"unit_type": 3, &"unit_class": 5, &"needed_xp": 900, &"attacks": [{
 &"attack_name": "Attack", &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 1, &"accuracy": 0.9, &"targets_needed": 1, &"initiative": 30, &"evadable": true, &"tags": [&"shot"]
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_archer_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
 "burn": [1, 25]
, "confused": [2, 0.5]
 
}, &"animation_index": 0, &"alternative_actions": []
 
}]
, &"effects": []
, &"base_damage": 30, &"max_hp": 140, &"armor": 0, &"evasion": 0.15, &"shielding_chance": 0.7, &"portrait_texture_path": "res://Arts/Placeholders/Will-o-whisp.jpg", &"custom_levelup_path": "", &"hero_abilities": "", &"map_effects": {
  
}, &"cost": {
 &"gold": 0, &"stone": 0, &"mana": 350 
} 
},&"Elemental" : {
 &"scene_path": "res://Combat/Units/Derived units//Elemental.tscn", &"level": 1, &"large_unit": false, &"immunities": []
, &"description": "Elementals are spirits of the magic, they roam the Fourfold without any innate purpose. Elementalists have learned how to communicate with them and summon them in times of need.", &"brief_description": "", &"faction": 5, &"unit_type": 2, &"unit_class": 0, &"needed_xp": 100, &"attacks": [{
 &"attack_name": "Attack", &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 1, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 40, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_archer_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
  
}, &"animation_index": 0, &"alternative_actions": []
 
}]
, &"effects": []
, &"base_damage": 30, &"max_hp": 100, &"armor": 0, &"evasion": 0.1, &"shielding_chance": 0.7, &"portrait_texture_path": "res://Arts/Placeholders/Elemental.jpg", &"custom_levelup_path": "", &"hero_abilities": "", &"map_effects": {
  
}, &"cost": {
 &"gold": 0, &"stone": 0, &"mana": 200 
} 
},&"Blade Saint" : {
 &"scene_path": "res://Combat/Units/Derived units//Empire/e08 Blade Saint.tscn", &"level": 4, &"large_unit": false, &"immunities": []
, &"description": "The most skilled warriors of Ari\'Tonia bear the name \"Blade Saint.\" Their moves are fluid and lightning fast. Renowned for their skills, they earn respect even from the Old Masters.", &"brief_description": "Melee fighter with increased evasion, double attack and increasing damage.", &"faction": 1, &"unit_type": 4, &"unit_class": 0, &"needed_xp": 1600, &"attacks": [{
 &"attack_name": "Attack", &"damage_multiplier": 0.65, &"damage_override": false, &"is_heal": false, &"type": 0, &"accuracy": 0.975, &"targets_needed": 2, &"initiative": 40, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_melee_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
  
}, &"animation_index": 0, &"alternative_actions": []
 
}]
, &"effects": [{
 &"effect_name": "Combo", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/combo.tscn", &"args": [30, 1.0]
 
}]
, &"base_damage": 80, &"max_hp": 275, &"armor": 35, &"evasion": 0.2, &"shielding_chance": 0.7, &"portrait_texture_path": "res://Arts/Placeholders/Blade saint.jpg", &"custom_levelup_path": "", &"hero_abilities": "", &"map_effects": {
  
}, &"cost": {
 &"gold": 800, &"stone": 150, &"mana": 50 
} 
},&"Elementalist" : {
 &"scene_path": "res://Combat/Units/Derived units//Empire/e15 Elementalist.tscn", &"level": 2, &"large_unit": false, &"immunities": []
, &"description": "Those who have learned to communicate with nature are called Elementalists. They call upon elemental spirits, summoning them to unleash their primordial power.", &"brief_description": "Mage that can summon units during battle.", &"faction": 1, &"unit_type": 2, &"unit_class": 5, &"needed_xp": 400, &"attacks": [{
 &"attack_name": "Attack", &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 1, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 30, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/elementalist_validity.tres", &"additional_targets": "", &"damage_policy": "res://Combat/Units/Parameters/Policy/elementalist_policy.tres", &"applying_effects": {
  
}, &"animation_index": 0, &"alternative_actions": []
 
}]
, &"effects": []
, &"base_damage": 30, &"max_hp": 75, &"armor": 0, &"evasion": 0.05, &"shielding_chance": 0.7, &"portrait_texture_path": "res://Arts/Placeholders/Elementalist.jpg", &"custom_levelup_path": "", &"hero_abilities": "", &"map_effects": {
  
}, &"cost": {
 &"gold": 150, &"stone": 0, &"mana": 100 
} 
},&"Imperial Ranger" : {
 &"scene_path": "res://Combat/Units/Derived units//Empire/e26 Imperial Ranger.tscn", &"level": 4, &"large_unit": false, &"immunities": []
, &"description": "Those who have proven themselves as skilled archers and valuable scouts are rewarded with the attire of the Imperial Ranger. Armed with enchanted bows, they shoot with precision to aid their allies.", &"brief_description": "Archer with multiple attacks, able to assist allies.", &"faction": 1, &"unit_type": 1, &"unit_class": 4, &"needed_xp": 1600, &"attacks": [{
 &"attack_name": "Attack", &"damage_multiplier": 0.25, &"damage_override": false, &"is_heal": false, &"type": 0, &"accuracy": 0.985, &"targets_needed": 1, &"initiative": 40, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_archer_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
  
}, &"animation_index": 0, &"alternative_actions": []
 
}, {
 &"attack_name": "Attack", &"damage_multiplier": 0.25, &"damage_override": false, &"is_heal": false, &"type": 0, &"accuracy": 0.985, &"targets_needed": 1, &"initiative": 30, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_archer_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
  
}, &"animation_index": 0, &"alternative_actions": []
 
}, {
 &"attack_name": "Attack", &"damage_multiplier": 0.25, &"damage_override": false, &"is_heal": false, &"type": 0, &"accuracy": 0.985, &"targets_needed": 1, &"initiative": 20, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_archer_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
  
}, &"animation_index": 0, &"alternative_actions": []
 
}, {
 &"attack_name": "Attack", &"damage_multiplier": 0.25, &"damage_override": false, &"is_heal": false, &"type": 0, &"accuracy": 0.985, &"targets_needed": 1, &"initiative": 10, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_archer_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
  
}, &"animation_index": 0, &"alternative_actions": []
 
}]
, &"effects": [{
 &"effect_name": "Agility", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/agility.tscn", &"args": [2, 1.2]
 
}, {
 &"effect_name": "Assistance", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/assistance.tscn", &"args": 0.5 
}]
, &"base_damage": 100, &"max_hp": 250, &"armor": 0, &"evasion": 0.296, &"shielding_chance": 0.7, &"portrait_texture_path": "res://Arts/Placeholders/Imperial ranger.jpg", &"custom_levelup_path": "", &"hero_abilities": "", &"map_effects": {
  
}, &"cost": {
 &"gold": 1000, &"stone": 500, &"mana": 100 
} 
},&"Samurai" : {
 &"scene_path": "res://Combat/Units/Derived units//Empire/e04 Samurai.tscn", &"level": 3, &"large_unit": false, &"immunities": []
, &"description": "Hailing from the distant continent of Ari\'Tonia, Samurai answer The Empire\'s call, honoring the ancient alliance that once united the world.", &"brief_description": "Melee fighter with increased evasion and double attack.", &"faction": 1, &"unit_type": 4, &"unit_class": 0, &"needed_xp": 900, &"attacks": [{
 &"attack_name": "Attack", &"damage_multiplier": 0.56, &"damage_override": false, &"is_heal": false, &"type": 0, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 40, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_melee_validity.tres", &"additional_targets": "res://Combat/Units/Parameters/Additional targets/Double_attack.tres", &"damage_policy": "", &"applying_effects": {
  
}, &"animation_index": 0, &"alternative_actions": []
 
}]
, &"effects": []
, &"base_damage": 60, &"max_hp": 200, &"armor": 20, &"evasion": 0.15, &"shielding_chance": 0.7, &"portrait_texture_path": "res://Arts/Placeholders/Samurai.jpg", &"custom_levelup_path": "", &"hero_abilities": "", &"map_effects": {
  
}, &"cost": {
 &"gold": 200, &"stone": 0, &"mana": 50 
} 
},&"Ritualist" : {
 &"scene_path": "res://Combat/Units/Derived units//Empire/e17 Ritualist.tscn", &"level": 3, &"large_unit": false, &"immunities": []
, &"description": "Through acrabe rituals, some mages weave bonds with the world\'s very spirits and command multiple elementals at once.", &"brief_description": "Mage able to summon multiple elementals.", &"faction": 1, &"unit_type": 2, &"unit_class": 5, &"needed_xp": 900, &"attacks": [{
 &"attack_name": "Attack", &"damage_multiplier": 0.6, &"damage_override": false, &"is_heal": false, &"type": 1, &"accuracy": 0.95, &"targets_needed": 2, &"initiative": 30, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/elementalist_validity.tres", &"additional_targets": "", &"damage_policy": "res://Combat/Units/Parameters/Policy/elementalist_policy.tres", &"applying_effects": {
  
}, &"animation_index": 0, &"alternative_actions": []
 
}]
, &"effects": []
, &"base_damage": 45, &"max_hp": 120, &"armor": 0, &"evasion": 0.05, &"shielding_chance": 0.7, &"portrait_texture_path": "res://Arts/Placeholders/Ritualist.jpg", &"custom_levelup_path": "", &"hero_abilities": "", &"map_effects": {
  
}, &"cost": {
 &"gold": 600, &"stone": 50, &"mana": 500 
} 
},&"Horseman" : {
 &"scene_path": "res://Combat/Units/Derived units//Empire/e07 Horseman.tscn", &"level": 3, &"large_unit": false, &"immunities": []
, &"description": "The mobile forces of the Kantarke are renowned for their ability to disrupt enemy formations and and strike decisive blows against their most vital positions.", &"brief_description": "Melee fighter that can move to attack its targets.", &"faction": 1, &"unit_type": 4, &"unit_class": 0, &"needed_xp": 900, &"attacks": [{
 &"attack_name": "Attack", &"damage_multiplier": 0.4, &"damage_override": false, &"is_heal": false, &"type": 0, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 70, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/melee_with_move.tres", &"additional_targets": "", &"damage_policy": "res://Combat/Units/Parameters/Policy/melee_with_move_policy.tres", &"applying_effects": {
  
}, &"animation_index": 0, &"alternative_actions": []
 
}, {
 &"attack_name": "Attack", &"damage_multiplier": 0.6, &"damage_override": false, &"is_heal": false, &"type": 0, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 40, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/melee_with_move.tres", &"additional_targets": "", &"damage_policy": "res://Combat/Units/Parameters/Policy/melee_with_move_policy.tres", &"applying_effects": {
  
}, &"animation_index": 0, &"alternative_actions": []
 
}]
, &"effects": []
, &"base_damage": 60, &"max_hp": 200, &"armor": 35, &"evasion": 0.05, &"shielding_chance": 0.7, &"portrait_texture_path": "res://Arts/Placeholders/Horseman.jpg", &"custom_levelup_path": "", &"hero_abilities": "", &"map_effects": {
  
}, &"cost": {
 &"gold": 200, &"stone": 50, &"mana": 0 
} 
},&"Paladin" : {
 &"scene_path": "res://Combat/Units/Derived units//Empire/e12 Paladin.tscn", &"level": 5, &"large_unit": false, &"immunities": []
, &"description": "In the hour of need, the Emperor personally grants the worthy the title of Paladin. Clad in crimson resolve, they are the last light of hope when the night of despair threatens to be eternal.", &"brief_description": "Melee fighter with multiple attacks, mobility and offensive aura.", &"faction": 1, &"unit_type": 4, &"unit_class": 0, &"needed_xp": 2500, &"attacks": [{
 &"attack_name": "Attack", &"damage_multiplier": 0.4, &"damage_override": false, &"is_heal": false, &"type": 0, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 70, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Derived units/Empire/e12 Paladin.tscn::Resource_rww7o", &"additional_targets": "", &"damage_policy": "res://Combat/Units/Parameters/Policy/melee_with_move_policy.tres", &"applying_effects": {
  
}, &"animation_index": 0, &"alternative_actions": []
 
}, {
 &"attack_name": "Attack", &"damage_multiplier": 0.5, &"damage_override": false, &"is_heal": false, &"type": 0, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 40, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Derived units/Empire/e12 Paladin.tscn::Resource_rww7o", &"additional_targets": "", &"damage_policy": "res://Combat/Units/Parameters/Policy/melee_with_move_policy.tres", &"applying_effects": {
  
}, &"animation_index": 0, &"alternative_actions": []
 
}, {
 &"attack_name": "Attack", &"damage_multiplier": 0.4, &"damage_override": false, &"is_heal": false, &"type": 0, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 30, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Derived units/Empire/e12 Paladin.tscn::Resource_rww7o", &"additional_targets": "", &"damage_policy": "res://Combat/Units/Parameters/Policy/melee_with_move_policy.tres", &"applying_effects": {
  
}, &"animation_index": 0, &"alternative_actions": []
 
}]
, &"effects": [{
 &"effect_name": "Giddy up", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/on_move_evasion_up.tscn", &"args": [1.7, 3]
 
}, {
 &"effect_name": "Damage buff Aura", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/damage_buff_aura.tscn", &"args": 40 
}]
, &"base_damage": 100, &"max_hp": 350, &"armor": 70, &"evasion": 0.05, &"shielding_chance": 0.8, &"portrait_texture_path": "res://Arts/Placeholders/Paladin.jpg", &"custom_levelup_path": "", &"hero_abilities": "", &"map_effects": {
  
}, &"cost": {
 &"gold": 1500, &"stone": 500, &"mana": 300 
} 
},&"Arcanist" : {
 &"scene_path": "res://Combat/Units/Derived units//Empire/e21 Arcanist.tscn", &"level": 5, &"large_unit": false, &"immunities": []
, &"description": "Transcending the limits of human soul and body, Arcanists weave their spells by commanding nature itself to eliminate their enemies. Tapping into the Element Temple, an Arcanist\'s power borders on divinity.", &"brief_description": "Powerful mage with huge damage but weak defense.", &"faction": 1, &"unit_type": 2, &"unit_class": 5, &"needed_xp": 2500, &"attacks": [{
 &"attack_name": "Attack", &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 1, &"accuracy": 0.85, &"targets_needed": 1, &"initiative": 30, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/any_unit.tres", &"additional_targets": "res://Combat/Units/Parameters/Additional targets/Splash.tres", &"damage_policy": "res://Combat/Units/Derived units/Empire/e21 Arcanist.tscn::Resource_xbk8a", &"applying_effects": {
 "electrified": [3, 18]
 
}, &"animation_index": 0, &"alternative_actions": []
 
}]
, &"effects": [{
 &"effect_name": "Defender", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/protect_on_attack.tscn", &"args": [50, true, 0.5, 0.3, -1, "res://Combat/Effects/Scenes/generic_blue_effect.tscn", "res://Combat/Effects/Scenes/shield.tscn"]
 
}, {
 &"effect_name": "Retaliation", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/retaliation.tscn", &"args": [30, {
 &"attack_name": "Attack", &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 1, &"accuracy": 1.0, &"targets_needed": 1, &"initiative": 0, &"evadable": false, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_mage_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
  
}, &"animation_index": 0, &"alternative_actions": []
 
}]
 
}]
, &"base_damage": 75, &"max_hp": 200, &"armor": 25, &"evasion": 0.05, &"shielding_chance": 0.7, &"portrait_texture_path": "res://Arts/Placeholders/Arcanist.jpg", &"custom_levelup_path": "", &"hero_abilities": "", &"map_effects": {
  
}, &"cost": {
 &"gold": 900, &"stone": 300, &"mana": 1800 
} 
},&"Knight Master" : {
 &"scene_path": "res://Combat/Units/Derived units//Empire/e06 Knight Master.tscn", &"level": 3, &"large_unit": false, &"immunities": []
, &"description": "The most noble of knights are granted the title of Knight Master. Their will an unbreakable bulwark, a living shield sworn to guard The Empire\'s cause.", &"brief_description": "Melee fighter with sturdy armor and ability to protect others.", &"faction": 1, &"unit_type": 4, &"unit_class": 0, &"needed_xp": 900, &"attacks": [{
 &"attack_name": "Attack", &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 0, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 40, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/melee_with_self.tres", &"additional_targets": "", &"damage_policy": "res://Combat/Units/Parameters/Policy/provoke_valid_targets_policy.tres", &"applying_effects": {
  
}, &"animation_index": 0, &"alternative_actions": []
 
}]
, &"effects": [{
 &"effect_name": "Taunt", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/taunt.tscn", &"args": [0.4, 0.65]
 
}]
, &"base_damage": 60, &"max_hp": 200, &"armor": 50, &"evasion": 0.05, &"shielding_chance": 0.7, &"portrait_texture_path": "res://Arts/Placeholders/Knight master.jpg", &"custom_levelup_path": "", &"hero_abilities": "", &"map_effects": {
  
}, &"cost": {
 &"gold": 220, &"stone": 70, &"mana": 0 
} 
},&"Scout" : {
 &"scene_path": "res://Combat/Units/Derived units//Empire/e24 Scout.tscn", &"level": 3, &"large_unit": false, &"immunities": []
, &"description": "An army is only as effective as its scouts are good. Imperial scouts are trained to spy on enemy forces and remain unnoticed.", &"brief_description": "Archer with debuff.", &"faction": 1, &"unit_type": 1, &"unit_class": 4, &"needed_xp": 900, &"attacks": [{
 &"attack_name": "Attack", &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 0, &"accuracy": 0.97, &"targets_needed": 1, &"initiative": 50, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_archer_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
 "vulnerability": [1, 30]
 
}, &"animation_index": 0, &"alternative_actions": []
 
}, {
 &"attack_name": "Attack", &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 0, &"accuracy": 0.97, &"targets_needed": 1, &"initiative": 50, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_archer_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
  
}, &"animation_index": 0, &"alternative_actions": []
 
}]
, &"effects": [{
 &"effect_name": "Agility", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/agility.tscn", &"args": [2, 0.0]
 
}]
, &"base_damage": 60, &"max_hp": 100, &"armor": 0, &"evasion": 0.208, &"shielding_chance": 0.7, &"portrait_texture_path": "res://Arts/Placeholders/Scout.jpg", &"custom_levelup_path": "", &"hero_abilities": "", &"map_effects": {
  
}, &"cost": {
 &"gold": 500, &"stone": 300, &"mana": 50 
} 
},&"Man at arms" : {
 &"scene_path": "res://Combat/Units/Derived units//Empire/man_at_arms.tscn", &"level": 3, &"large_unit": false, &"immunities": []
, &"description": "", &"brief_description": "", &"faction": 1, &"unit_type": 4, &"unit_class": 0, &"needed_xp": 900, &"attacks": [{
 &"attack_name": "Attack", &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 0, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 40, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_melee_validity.tres", &"additional_targets": "res://Combat/Units/Parameters/Additional targets/Double_attack.tres", &"damage_policy": "", &"applying_effects": {
  
}, &"animation_index": 0, &"alternative_actions": []
 
}]
, &"effects": [{
 &"effect_name": "Positive alignment", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/positive_alignment.tscn", &"args": 1 
}]
, &"base_damage": 60, &"max_hp": 220, &"armor": 60, &"evasion": 0.05, &"shielding_chance": 0.7, &"portrait_texture_path": "", &"custom_levelup_path": "", &"hero_abilities": "", &"map_effects": {
  
}, &"cost": {
 &"gold": 320, &"stone": 0, &"mana": 0 
} 
},&"Squire" : {
 &"scene_path": "res://Combat/Units/Derived units//Empire/e01 Squire.tscn", &"level": 1, &"large_unit": false, &"immunities": []
, &"description": "Squires are not usually considered a part of the main force of The Empire but they stand ready to defend the weak with all their skill.", &"brief_description": "Melee fighter. Weak but will do everything he can.", &"faction": 1, &"unit_type": 4, &"unit_class": 0, &"needed_xp": 150, &"attacks": [{
 &"attack_name": "Attack", &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 0, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 40, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_melee_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
  
}, &"animation_index": 0, &"alternative_actions": []
 
}]
, &"effects": []
, &"base_damage": 30, &"max_hp": 100, &"armor": 0, &"evasion": 0.05, &"shielding_chance": 0.7, &"portrait_texture_path": "res://Arts/Placeholders/Squire.jpg", &"custom_levelup_path": "", &"hero_abilities": "", &"map_effects": {
  
}, &"cost": {
 &"gold": 70, &"stone": 0, &"mana": 0 
} 
},&"Apprentice" : {
 &"scene_path": "res://Combat/Units/Derived units//Empire/e14 Apprentice.tscn", &"level": 1, &"large_unit": false, &"immunities": []
, &"description": "Ambitious apprentices step from study into battle as battle mages. Though fragile, they can conjure lightning bolts to cover the advance of larger forces.", &"brief_description": "Ranged fragile mage.", &"faction": 1, &"unit_type": 2, &"unit_class": 5, &"needed_xp": 80, &"attacks": [{
 &"attack_name": "Attack", &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 1, &"accuracy": 0.9, &"targets_needed": 1, &"initiative": 30, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_mage_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
  
}, &"animation_index": 0, &"alternative_actions": []
 
}]
, &"effects": []
, &"base_damage": 20, &"max_hp": 50, &"armor": 0, &"evasion": 0.05, &"shielding_chance": 0.7, &"portrait_texture_path": "res://Arts/Placeholders/Apprentice.jpg", &"custom_levelup_path": "", &"hero_abilities": "", &"map_effects": {
  
}, &"cost": {
 &"gold": 90, &"stone": 0, &"mana": 30 
} 
},&"Archer" : {
 &"scene_path": "res://Combat/Units/Derived units//Empire/e22 Archer.tscn", &"level": 1, &"large_unit": false, &"immunities": []
, &"description": "Every army needs the support of ranged units, and archers are often relied upon to pick off the enemy\'s support or assist the primary assault forces.", &"brief_description": "Weak archer.", &"faction": 1, &"unit_type": 1, &"unit_class": 4, &"needed_xp": 1, &"attacks": [{
 &"attack_name": "Attack", &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 0, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 50, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_archer_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
  
}, &"animation_index": 0, &"alternative_actions": []
 
}]
, &"effects": []
, &"base_damage": 30, &"max_hp": 50, &"armor": 0, &"evasion": 0.05, &"shielding_chance": 0.7, &"portrait_texture_path": "res://Arts/Placeholders/Archer.jpg", &"custom_levelup_path": "", &"hero_abilities": "", &"map_effects": {
  
}, &"cost": {
 &"gold": 70, &"stone": 10, &"mana": 0 
} 
},&"Keeper of Knowledge" : {
 &"scene_path": "res://Combat/Units/Derived units//Empire/e20 Keeper of Knowledge.tscn", &"level": 5, &"large_unit": false, &"immunities": []
, &"description": "To look beyond reality\'s veil is to risk madness. The rare few who retain their sanity become Keepers of Knowledge, eternally silent, for what they know should never be described in human language. Their mere gaze upon the battlefield can turn the tides.", &"brief_description": "Mage with strong debuff on a single unit.", &"faction": 1, &"unit_type": 2, &"unit_class": 5, &"needed_xp": 2500, &"attacks": [{
 &"attack_name": "Attack", &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 1, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 30, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/any_unit.tres", &"additional_targets": "", &"damage_policy": "res://Combat/Units/Parameters/Policy/filter_allies_policy.tres", &"applying_effects": {
 "exposed": 2 
}, &"animation_index": 0, &"alternative_actions": []
 
}]
, &"effects": [{
 &"effect_name": "All-knowing", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/change_attack_type.tscn", &"args": 2 
}]
, &"base_damage": 100, &"max_hp": 200, &"armor": 0, &"evasion": 0.05, &"shielding_chance": 0.7, &"portrait_texture_path": "res://Arts/Placeholders/Keeper of knowledge.jpg", &"custom_levelup_path": "", &"hero_abilities": "", &"map_effects": {
  
}, &"cost": {
 &"gold": 1000, &"stone": 200, &"mana": 1500 
} 
},&"Mage" : {
 &"scene_path": "res://Combat/Units/Derived units//Empire/e16 Mage.tscn", &"level": 2, &"large_unit": false, &"immunities": []
, &"description": "Over time apprentice makes themselves a name and can be called a Mage. As their experience grows, so does their knowledge and power of their spells.", &"brief_description": "Fragile mage.", &"faction": 1, &"unit_type": 2, &"unit_class": 5, &"needed_xp": 400, &"attacks": [{
 &"attack_name": "Attack", &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 1, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 30, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/any_unit.tres", &"additional_targets": "", &"damage_policy": "res://Combat/Units/Derived units/Empire/e16 Mage.tscn::Resource_6f3w4", &"applying_effects": {
  
}, &"animation_index": 0, &"alternative_actions": []
 
}]
, &"effects": []
, &"base_damage": 30, &"max_hp": 75, &"armor": 0, &"evasion": 0.05, &"shielding_chance": 0.7, &"portrait_texture_path": "res://Arts/Placeholders/Mage.jpg", &"custom_levelup_path": "", &"hero_abilities": "", &"map_effects": {
  
}, &"cost": {
 &"gold": 200, &"stone": 0, &"mana": 80 
} 
},&"Royal Cavalier" : {
 &"scene_path": "res://Combat/Units/Derived units//Empire/e11 Royal Cavalier.tscn", &"level": 4, &"large_unit": false, &"immunities": []
, &"description": "Those who serve in the personal forces of lords and counts are called Royal Cavaliers. They ride the best steeds The Empire can offer and wield the finest armor and weapons from the royal armories.", &"brief_description": "Melee fighter with multiple attacks per round and mobility.", &"faction": 1, &"unit_type": 4, &"unit_class": 0, &"needed_xp": 1600, &"attacks": [{
 &"attack_name": "Attack", &"damage_multiplier": 0.5, &"damage_override": false, &"is_heal": false, &"type": 0, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 60, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/melee_with_move.tres", &"additional_targets": "", &"damage_policy": "res://Combat/Units/Parameters/Policy/melee_with_move_policy.tres", &"applying_effects": {
  
}, &"animation_index": 0, &"alternative_actions": []
 
}, {
 &"attack_name": "Attack", &"damage_multiplier": 0.4, &"damage_override": false, &"is_heal": false, &"type": 0, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 40, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/melee_with_move.tres", &"additional_targets": "", &"damage_policy": "res://Combat/Units/Parameters/Policy/melee_with_move_policy.tres", &"applying_effects": {
  
}, &"animation_index": 0, &"alternative_actions": []
 
}, {
 &"attack_name": "Attack", &"damage_multiplier": 0.3, &"damage_override": false, &"is_heal": false, &"type": 0, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 35, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/melee_with_move.tres", &"additional_targets": "", &"damage_policy": "res://Combat/Units/Parameters/Policy/melee_with_move_policy.tres", &"applying_effects": {
  
}, &"animation_index": 0, &"alternative_actions": []
 
}]
, &"effects": [{
 &"effect_name": "Giddy up", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/on_move_evasion_up.tscn", &"args": [1.5, 1]
 
}]
, &"base_damage": 80, &"max_hp": 275, &"armor": 50, &"evasion": 0.05, &"shielding_chance": 0.7, &"portrait_texture_path": "res://Arts/Placeholders/Royal cavalier.jpg", &"custom_levelup_path": "", &"hero_abilities": "", &"map_effects": {
  
}, &"cost": {
 &"gold": 800, &"stone": 300, &"mana": 100 
} 
},&"Angel" : {
 &"scene_path": "res://Combat/Units/Derived units//Empire/e13 Angel.tscn", &"level": 5, &"large_unit": false, &"immunities": []
, &"description": "The War of Establishment shakes the foundation of the Fourfold, and even celestial pride must be put away as the threat is looming over all the living. When angel descend - deathless beings with swords of pure light - and join the battle, nothing can stand in their way.", &"brief_description": "Melee fighters with high damage and defensive aura.", &"faction": 1, &"unit_type": 4, &"unit_class": 0, &"needed_xp": 2500, &"attacks": [{
 &"attack_name": "Attack", &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 1, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 40, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_melee_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
  
}, &"animation_index": 0, &"alternative_actions": [{
 &"attack_name": "Purification", &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 4, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 40, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/any_unit.tres", &"additional_targets": "", &"damage_policy": "res://Combat/Units/Parameters/Policy/purify_policy.tres", &"applying_effects": {
  
}, &"animation_index": 0, &"alternative_actions": []
 
}]
 
}]
, &"effects": [{
 &"effect_name": "Armor buff Aura", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/armor_buff_aura.tscn", &"args": 30 
}, {
 &"effect_name": "Divine nature", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/cheat_death.tscn", &"args": [1, 1]
 
}]
, &"base_damage": 100, &"max_hp": 350, &"armor": 50, &"evasion": 0.05, &"shielding_chance": 0.7, &"portrait_texture_path": "res://Arts/Placeholders/Angel.jpg", &"custom_levelup_path": "", &"hero_abilities": "", &"map_effects": {
  
}, &"cost": {
 &"gold": 1000, &"stone": 300, &"mana": 800 
} 
},&"White Mage" : {
 &"scene_path": "res://Combat/Units/Derived units//Empire/e19 White Mage.tscn", &"level": 4, &"large_unit": false, &"immunities": []
, &"description": "Only the most talented and peerless of battle mages can be granted the title of White Mage. These spellcasters bend the fabric of reality to unleash brimstone and storms upon any foolish enough to oppose The Empire.", &"brief_description": "Powerdul mage.", &"faction": 1, &"unit_type": 2, &"unit_class": 5, &"needed_xp": 1600, &"attacks": [{
 &"attack_name": "Attack", &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 1, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 70, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/any_unit.tres", &"additional_targets": "res://Combat/Units/Parameters/Additional targets/Splash.tres", &"damage_policy": "res://Combat/Units/Derived units/Empire/e19 White Mage.tscn::Resource_yeav1", &"applying_effects": {
 "electrified": [2, 10]
 
}, &"animation_index": 0, &"alternative_actions": []
 
}]
, &"effects": []
, &"base_damage": 65, &"max_hp": 180, &"armor": 0, &"evasion": 0.05, &"shielding_chance": 0.7, &"portrait_texture_path": "res://Arts/Placeholders/White mage.jpg", &"custom_levelup_path": "", &"hero_abilities": "", &"map_effects": {
  
}, &"cost": {
 &"gold": 850, &"stone": 300, &"mana": 1200 
} 
},&"Gendarme" : {
 &"scene_path": "res://Combat/Units/Derived units//Empire/gendarme.tscn", &"level": 4, &"large_unit": false, &"immunities": []
, &"description": "", &"brief_description": "", &"faction": 1, &"unit_type": 4, &"unit_class": 0, &"needed_xp": 1250, &"attacks": [{
 &"attack_name": "Attack", &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 0, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 0, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_melee_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
  
}, &"animation_index": 0, &"alternative_actions": []
 
}]
, &"effects": [{
 &"effect_name": "Undefined", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/encouragement.tscn", &"args": 1 
}]
, &"base_damage": 80, &"max_hp": 350, &"armor": 80, &"evasion": 0.05, &"shielding_chance": 0.85, &"portrait_texture_path": "", &"custom_levelup_path": "", &"hero_abilities": "", &"map_effects": {
  
}, &"cost": {
 &"gold": 0, &"stone": 0, &"mana": 0 
} 
},&"Knight" : {
 &"scene_path": "res://Combat/Units/Derived units//Empire/e03 Knight.tscn", &"level": 2, &"large_unit": false, &"immunities": []
, &"description": "Knights devote their lives to guarding The Empire  against all who dare oppose The Empire\'s will.", &"brief_description": "Melee fighter with increased armor.", &"faction": 1, &"unit_type": 4, &"unit_class": 0, &"needed_xp": 400, &"attacks": [{
 &"attack_name": "Attack", &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 0, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 40, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_melee_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
  
}, &"animation_index": 0, &"alternative_actions": []
 
}]
, &"effects": [{
 &"effect_name": "Taunt", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/taunt.tscn", &"args": [0.3, 1.0]
 
}]
, &"base_damage": 45, &"max_hp": 150, &"armor": 20, &"evasion": 0.05, &"shielding_chance": 0.7, &"portrait_texture_path": "res://Arts/Placeholders/Knight.jpg", &"custom_levelup_path": "", &"hero_abilities": "", &"map_effects": {
  
}, &"cost": {
 &"gold": 140, &"stone": 10, &"mana": 0 
} 
},&"Marksman" : {
 &"scene_path": "res://Combat/Units/Derived units//Empire/e23 Marksman.tscn", &"level": 2, &"large_unit": false, &"immunities": []
, &"description": "Through years of practice, Marksmen hone their skills, develop precise, lethal accuracy with bow, standing ever-ready to support the army\'s efforts.", &"brief_description": "Weak archer with increased accuracy.", &"faction": 1, &"unit_type": 1, &"unit_class": 4, &"needed_xp": 400, &"attacks": [{
 &"attack_name": "Attack", &"damage_multiplier": 0.5, &"damage_override": false, &"is_heal": false, &"type": 0, &"accuracy": 0.96, &"targets_needed": 1, &"initiative": 50, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_archer_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
  
}, &"animation_index": 0, &"alternative_actions": []
 
}, {
 &"attack_name": "Attack", &"damage_multiplier": 25.0, &"damage_override": true, &"is_heal": false, &"type": 0, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 35, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_archer_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
  
}, &"animation_index": 0, &"alternative_actions": []
 
}]
, &"effects": []
, &"base_damage": 45, &"max_hp": 75, &"armor": 0, &"evasion": 0.136, &"shielding_chance": 0.7, &"portrait_texture_path": "res://Arts/Placeholders/Marksman.jpg", &"custom_levelup_path": "", &"hero_abilities": "", &"map_effects": {
  
}, &"cost": {
 &"gold": 200, &"stone": 30, &"mana": 0 
} 
},&"Wizard" : {
 &"scene_path": "res://Combat/Units/Derived units//Empire/e18 Wizard.tscn", &"level": 3, &"large_unit": false, &"immunities": []
, &"description": "Wizards wield devastating spells to wipe out entire armies. Commanding the power of lightning, they are a formidable force to any commander.", &"brief_description": "Fragile mage.", &"faction": 1, &"unit_type": 2, &"unit_class": 5, &"needed_xp": 900, &"attacks": [{
 &"attack_name": "Attack", &"damage_multiplier": 0.85, &"damage_override": false, &"is_heal": false, &"type": 1, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 30, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/any_unit.tres", &"additional_targets": "res://Combat/Units/Parameters/Additional targets/Splash.tres", &"damage_policy": "res://Combat/Units/Parameters/Policy/applying_shield_policy.tres", &"applying_effects": {
  
}, &"animation_index": 0, &"alternative_actions": []
 
}]
, &"effects": []
, &"base_damage": 45, &"max_hp": 110, &"armor": 0, &"evasion": 0.05, &"shielding_chance": 0.7, &"portrait_texture_path": "res://Arts/Placeholders/Wizard.jpg", &"custom_levelup_path": "", &"hero_abilities": "", &"map_effects": {
  
}, &"cost": {
 &"gold": 400, &"stone": 150, &"mana": 800 
} 
},&"Assassin" : {
 &"scene_path": "res://Combat/Units/Derived units//Empire/e25 Assassin.tscn", &"level": 3, &"large_unit": false, &"immunities": []
, &"description": "Acting from the shadows, Assassins pick off unsuspecting victims, unconcerned with honor and valor. When duty demands, even the most righteous of generals must rely on their services.", &"brief_description": "Archer with multiple poisoned attacks.", &"faction": 1, &"unit_type": 1, &"unit_class": 3, &"needed_xp": 900, &"attacks": [{
 &"attack_name": "Attack", &"damage_multiplier": 0.5, &"damage_override": false, &"is_heal": false, &"type": 0, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 50, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_archer_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
 "Poison": [15, 3]
 
}, &"animation_index": 0, &"alternative_actions": []
 
}, {
 &"attack_name": "Attack", &"damage_multiplier": 0.5, &"damage_override": false, &"is_heal": false, &"type": 0, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 50, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_archer_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
 "Poison": [20, 2]
 
}, &"animation_index": 0, &"alternative_actions": []
 
}]
, &"effects": [{
 &"effect_name": "Agility", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/agility.tscn", &"args": [2, 1.2]
 
}]
, &"base_damage": 75, &"max_hp": 85, &"armor": -20, &"evasion": 0.3, &"shielding_chance": 0.7, &"portrait_texture_path": "res://Arts/Placeholders/Assassin.jpg", &"custom_levelup_path": "", &"hero_abilities": "", &"map_effects": {
  
}, &"cost": {
 &"gold": 1000, &"stone": 0, &"mana": 0 
} 
},&"Angel Knight" : {
 &"scene_path": "res://Combat/Units/Derived units//Empire/e10 Angel Knight.tscn", &"level": 4, &"large_unit": false, &"immunities": []
, &"description": "When the Sin Keeper began its march, many angels - who are usually too proud and consider themselves above other mortals - looked upon humanity with mercy. They took up the knightly vow, protecting the weak with the celestial powers.", &"brief_description": "Melee fighter with increased armor and ability to restore other\'s health.", &"faction": 1, &"unit_type": 4, &"unit_class": 0, &"needed_xp": 1600, &"attacks": [{
 &"attack_name": "Attack", &"damage_multiplier": 0.5, &"damage_override": false, &"is_heal": false, &"type": 1, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 40, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/melee_with_self.tres", &"additional_targets": "", &"damage_policy": "res://Combat/Units/Derived units/Empire/e10 Angel Knight.tscn::Resource_5c7t2", &"applying_effects": {
  
}, &"animation_index": 0, &"alternative_actions": []
 
}, {
 &"attack_name": "Attack", &"damage_multiplier": 0.5, &"damage_override": false, &"is_heal": false, &"type": 1, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 30, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/melee_with_self.tres", &"additional_targets": "", &"damage_policy": "res://Combat/Units/Derived units/Empire/e10 Angel Knight.tscn::Resource_5c7t2", &"applying_effects": {
  
}, &"animation_index": 0, &"alternative_actions": []
 
}]
, &"effects": [{
 &"effect_name": "Divine nature", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/cheat_death.tscn", &"args": [1, 1]
 
}, {
 &"effect_name": "Taunt", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/taunt.tscn", &"args": [0.5, 0.55]
 
}, {
 &"effect_name": "Healing aura", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/on_turn_heal.tscn", &"args": 25 
}]
, &"base_damage": 80, &"max_hp": 275, &"armor": 80, &"evasion": 0.05, &"shielding_chance": 0.85, &"portrait_texture_path": "res://Arts/Placeholders/Angel knight.jpg", &"custom_levelup_path": "", &"hero_abilities": "", &"map_effects": {
  
}, &"cost": {
 &"gold": 500, &"stone": 150, &"mana": 500 
} 
},&"Inquisitor" : {
 &"scene_path": "res://Combat/Units/Derived units//Church/e05 Inquisitor.tscn", &"level": 3, &"large_unit": false, &"immunities": []
, &"description": "When a witch hunter proves their devotion to the Church in battle, they are accepted as an Inquisitor. The Inquisition relentlessly pursues everything evil in this world, mercilessly burning heresies and the unfaithful with brimstone and prayer.", &"brief_description": "Melee fighter with unblockable attacks.", &"faction": 3, &"unit_type": 4, &"unit_class": 0, &"needed_xp": 900, &"attacks": [{
 &"attack_name": "Attack", &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 4, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 40, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_melee_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
  
}, &"animation_index": 0, &"alternative_actions": []
 
}]
, &"effects": [{
 &"effect_name": "Sturdy will", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/retaliation_on_debuff.tscn", &"args": 1.2 
}, {
 &"effect_name": "Holy wrath", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/holy_wrath.tscn", &"args": [2, 1.3]
 
}, {
 &"effect_name": "Ward", &"effect_path": "res://Combat/Effects/AppliedEffects/Scenes/ward.tscn", &"args": [2, 1]
 
}]
, &"base_damage": 60, &"max_hp": 200, &"armor": 20, &"evasion": 0.1, &"shielding_chance": 0.6, &"portrait_texture_path": "res://Arts/Placeholders/Inquisitor.jpg", &"custom_levelup_path": "", &"hero_abilities": "", &"map_effects": {
  
}, &"cost": {
 &"gold": 250, &"stone": 0, &"mana": 30 
} 
},&"Witch hunter" : {
 &"scene_path": "res://Combat/Units/Derived units//Church/e02 Witch hunter.tscn", &"level": 2, &"large_unit": false, &"immunities": []
, &"description": "Trained by the Church to hunt down lesser evil spawns, witch hunters are skilled with blade and zeal. Though officially not part of the Inquisition, witch hunters serve The Empire as wards against darkness.", &"brief_description": "Melee fighter with increased evasion.", &"faction": 3, &"unit_type": 4, &"unit_class": 0, &"needed_xp": 400, &"attacks": [{
 &"attack_name": "Attack", &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 0, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 40, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_melee_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
  
}, &"animation_index": 0, &"alternative_actions": []
 
}]
, &"effects": []
, &"base_damage": 45, &"max_hp": 150, &"armor": 10, &"evasion": 0.1, &"shielding_chance": 0.7, &"portrait_texture_path": "res://Arts/Placeholders/Witch hunter.jpg", &"custom_levelup_path": "", &"hero_abilities": "", &"map_effects": {
  
}, &"cost": {
 &"gold": 130, &"stone": 0, &"mana": 10 
} 
},&"Cleric" : {
 &"scene_path": "res://Combat/Units/Derived units//Church/e28 Cleric.tscn", &"level": 2, &"large_unit": false, &"immunities": []
, &"description": "Gods may be hesitant to respond to prayers, but with enough diligence and faith, Clerics can bestow divine blessings upon the army, healing bodies and strengthening minds.", &"brief_description": "Weak healer, able to heal the entire party.", &"faction": 3, &"unit_type": 3, &"unit_class": 0, &"needed_xp": 400, &"attacks": [{
 &"attack_name": "Attack", &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": true, &"type": 3, &"accuracy": 1.0, &"targets_needed": 1, &"initiative": 0, &"evadable": false, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_healer_validity.tres", &"additional_targets": "res://Combat/Units/Parameters/Additional targets/mass_heal_targets.tres", &"damage_policy": "", &"applying_effects": {
  
}, &"animation_index": 0, &"alternative_actions": []
 
}]
, &"effects": []
, &"base_damage": 25, &"max_hp": 100, &"armor": 0, &"evasion": 0.05, &"shielding_chance": 0.7, &"portrait_texture_path": "res://Arts/Placeholders/Cleric.jpg", &"custom_levelup_path": "", &"hero_abilities": "", &"map_effects": {
  
}, &"cost": {
 &"gold": 100, &"stone": 30, &"mana": 100 
} 
},&"Imperial priest" : {
 &"scene_path": "res://Combat/Units/Derived units//Church/e31 Imperial priest.tscn", &"level": 3, &"large_unit": false, &"immunities": []
, &"description": "\"... Thou art as dust beneath the feet of the Gods. Let all bear witness that thy deeds are the Church\'s bidding, not thy will. Thy tongue now speaketh with the Church\'s voice; thy light is a gift bestowed by the very Gods.\"\nFrom the \"Level 2 Ordination ceremony\", issued by decree #16-857 of The Church, approved by Council of Thorns.", &"brief_description": "Single-targrt strong healer able to cure allies.", &"faction": 3, &"unit_type": 3, &"unit_class": 0, &"needed_xp": 900, &"attacks": [{
 &"attack_name": "Attack", &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": true, &"type": 3, &"accuracy": 1.0, &"targets_needed": 1, &"initiative": 10, &"evadable": false, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_healer_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
 "cure": null 
}, &"animation_index": 0, &"alternative_actions": []
 
}]
, &"effects": []
, &"base_damage": 60, &"max_hp": 150, &"armor": 0, &"evasion": 0.05, &"shielding_chance": 0.7, &"portrait_texture_path": "res://Arts/Placeholders/Clergyman.jpg", &"custom_levelup_path": "", &"hero_abilities": "", &"map_effects": {
  
}, &"cost": {
 &"gold": 800, &"stone": 300, &"mana": 0 
} 
},&"Hierophant" : {
 &"scene_path": "res://Combat/Units/Derived units//Church/e33 Hierophant.tscn", &"level": 4, &"large_unit": false, &"immunities": []
, &"description": "\"... We hereby welcome thee as the face of the Church. Thine will shall now be the will of the Church, and thine heart shall belong to the Council of Thorns.\"\n- Council of Thorns", &"brief_description": "Single-target healer able to resurret fallen warriors.", &"faction": 3, &"unit_type": 3, &"unit_class": 0, &"needed_xp": 1600, &"attacks": [{
 &"attack_name": "Attack", &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": true, &"type": 3, &"accuracy": 1.0, &"targets_needed": 1, &"initiative": 15, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/resurrection_validation.tres", &"additional_targets": "", &"damage_policy": "res://Combat/Units/Parameters/Policy/resurrection_policy.tres", &"applying_effects": {
  
}, &"animation_index": 0, &"alternative_actions": []
 
}]
, &"effects": []
, &"base_damage": 80, &"max_hp": 180, &"armor": 0, &"evasion": 0.05, &"shielding_chance": 0.7, &"portrait_texture_path": "res://Arts/Placeholders/Hierophant.jpg", &"custom_levelup_path": "", &"hero_abilities": "", &"map_effects": {
  
}, &"cost": {
 &"gold": 2000, &"stone": 500, &"mana": 0 
} 
},&"Priest" : {
 &"scene_path": "res://Combat/Units/Derived units//Church/e29 Priest.tscn", &"level": 2, &"large_unit": false, &"immunities": []
, &"description": "Through firm faith, Priests strengthen the bodies of combatants, healing them with divine magic and allowing them to endure against evil a little longer.", &"brief_description": "Single-target healer.", &"faction": 3, &"unit_type": 3, &"unit_class": 0, &"needed_xp": 400, &"attacks": [{
 &"attack_name": "Attack", &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": true, &"type": 3, &"accuracy": 1.0, &"targets_needed": 1, &"initiative": 10, &"evadable": false, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_healer_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
 "cure": null 
}, &"animation_index": 0, &"alternative_actions": []
 
}]
, &"effects": []
, &"base_damage": 40, &"max_hp": 110, &"armor": 0, &"evasion": 0.05, &"shielding_chance": 0.7, &"portrait_texture_path": "res://Arts/Placeholders/Priest.jpg", &"custom_levelup_path": "", &"hero_abilities": "", &"map_effects": {
  
}, &"cost": {
 &"gold": 300, &"stone": 50, &"mana": 0 
} 
},&"Prophetess" : {
 &"scene_path": "res://Combat/Units/Derived units//Church/e32 Prophetess.tscn", &"level": 4, &"large_unit": false, &"immunities": []
, &"description": "\"... Let it be known that a new Eye has opened within the Church. Thou art the all-seer, the teller of the divine will. Prophetess we declare thee! Stand thou with us, our sister and our peer, and share in our rejoicing.\"\n- Voices of the Council of Thorns", &"brief_description": "Mass-healer with strong buffs", &"faction": 3, &"unit_type": 3, &"unit_class": 0, &"needed_xp": 1600, &"attacks": [{
 &"attack_name": "Attack", &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": true, &"type": 3, &"accuracy": 1.0, &"targets_needed": 1, &"initiative": 10, &"evadable": false, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_healer_validity.tres", &"additional_targets": "res://Combat/Units/Parameters/Additional targets/mass_heal_targets.tres", &"damage_policy": "", &"applying_effects": {
 "random_buff": [2, 20, 1.2]
 
}, &"animation_index": 0, &"alternative_actions": []
 
}]
, &"effects": []
, &"base_damage": 65, &"max_hp": 195, &"armor": 0, &"evasion": 0.05, &"shielding_chance": 0.7, &"portrait_texture_path": "res://Arts/Placeholders/Prophetess.jpg", &"custom_levelup_path": "", &"hero_abilities": "", &"map_effects": {
  
}, &"cost": {
 &"gold": 1000, &"stone": 0, &"mana": 1000 
} 
},&"Acolyte" : {
 &"scene_path": "res://Combat/Units/Derived units//Church/e27 Acolyte.tscn", &"level": 1, &"large_unit": false, &"immunities": []
, &"description": "Though their faith might be weak, Acolyte\'s compassion for the suffering allows them to cure wounds on the battlefield.", &"brief_description": "Healer.", &"faction": 3, &"unit_type": 3, &"unit_class": 0, &"needed_xp": 1, &"attacks": [{
 &"attack_name": "Attack", &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": true, &"type": 3, &"accuracy": 1.0, &"targets_needed": 1, &"initiative": 10, &"evadable": false, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_healer_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
  
}, &"animation_index": 0, &"alternative_actions": []
 
}]
, &"effects": []
, &"base_damage": 20, &"max_hp": 70, &"armor": 0, &"evasion": 0.05, &"shielding_chance": 0.7, &"portrait_texture_path": "res://Arts/Placeholders/Acolyte.jpg", &"custom_levelup_path": "", &"hero_abilities": "", &"map_effects": {
  
}, &"cost": {
 &"gold": 50, &"stone": 0, &"mana": 50 
} 
},&"Matriarch" : {
 &"scene_path": "res://Combat/Units/Derived units//Church/e30 Matriarch.tscn", &"level": 3, &"large_unit": false, &"immunities": []
, &"description": "\"... Thus we name thee Matriarch. Thy duty is graven upon thine heart, mirrored in thy will. Thou art a shaft of light that cleaveth the deepest dark, and thy visage shall kindle hope in the hearts of all who look upon thee.\"\nFrom the \"Level 2 Ordination ceremony\", issued by decree #16-857 of The Church, approved by Council of Thorns.", &"brief_description": "Mass-healer able to buff allies.", &"faction": 3, &"unit_type": 3, &"unit_class": 0, &"needed_xp": 900, &"attacks": [{
 &"attack_name": "Attack", &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": true, &"type": 3, &"accuracy": 1.0, &"targets_needed": 1, &"initiative": 10, &"evadable": false, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_healer_validity.tres", &"additional_targets": "res://Combat/Units/Parameters/Additional targets/mass_heal_targets.tres", &"damage_policy": "", &"applying_effects": {
 "random_buff": [1, 5, 1.1]
 
}, &"animation_index": 0, &"alternative_actions": []
 
}]
, &"effects": []
, &"base_damage": 45, &"max_hp": 150, &"armor": 0, &"evasion": 0.05, &"shielding_chance": 0.7, &"portrait_texture_path": "res://Arts/Placeholders/Matriarch.jpg", &"custom_levelup_path": "", &"hero_abilities": "", &"map_effects": {
  
}, &"cost": {
 &"gold": 600, &"stone": 0, &"mana": 600 
} 
},&"High Inquisitor" : {
 &"scene_path": "res://Combat/Units/Derived units//Church/e09 Grand Inquisitor.tscn", &"level": 4, &"large_unit": false, &"immunities": []
, &"description": "\"... Arise now as High Inquisitor, bound henceforth by thine oath. Let thy soul stay pure, thy arm strong \'gainst all ill, for the Gods look down upon thy path, and Their holy ire shall scourge the bold who stand between thy will and destiny\'s fulfillment.\"\nFasteur de Miora, Praefectus Dei", &"brief_description": "Melee fighter with unblockable attacks, immute to negative effects.", &"faction": 3, &"unit_type": 4, &"unit_class": 0, &"needed_xp": 1600, &"attacks": [{
 &"attack_name": "Attack", &"damage_multiplier": 0.85, &"damage_override": false, &"is_heal": false, &"type": 4, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 40, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_melee_validity.tres", &"additional_targets": "res://Combat/Units/Parameters/Additional targets/Splash.tres", &"damage_policy": "res://Combat/Units/Derived units/Church/e09 Grand Inquisitor.tscn::Resource_6n8jw", &"applying_effects": {
  
}, &"animation_index": 0, &"alternative_actions": []
 
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
, &"base_damage": 80, &"max_hp": 275, &"armor": 35, &"evasion": 0.15, &"shielding_chance": 0.6, &"portrait_texture_path": "res://Arts/Placeholders/Grand inquisitor.jpg", &"custom_levelup_path": "", &"hero_abilities": "", &"map_effects": {
  
}, &"cost": {
 &"gold": 700, &"stone": 100, &"mana": 200 
} 
},&"Pirate capitan" : {
 &"scene_path": "res://Combat/Units/Derived units//Neutral/pirate_captain.tscn", &"level": 4, &"large_unit": false, &"immunities": []
, &"description": "Pirate Captains are charismatic and ruthless leaders, commanding their crews with a mix of fear and admiration. Their combat skills are matched by their ability to inspire their followers, turning a ragtag crew into a formidable fighting force.", &"brief_description": "", &"faction": 6, &"unit_type": 4, &"unit_class": 0, &"needed_xp": 1600, &"attacks": [{
 &"attack_name": "Attack", &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 0, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 40, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_melee_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
  
}, &"animation_index": 0, &"alternative_actions": []
 
}]
, &"effects": []
, &"base_damage": 90, &"max_hp": 275, &"armor": 20, &"evasion": 0.1, &"shielding_chance": 0.3, &"portrait_texture_path": "res://Arts/Placeholders/Pirate captain.jpg", &"custom_levelup_path": "", &"hero_abilities": "", &"map_effects": {
  
}, &"cost": {
 &"gold": 0, &"stone": 0, &"mana": 0 
} 
},&"Orc" : {
 &"scene_path": "res://Combat/Units/Derived units//Neutral/orc.tscn", &"level": 2, &"large_unit": false, &"immunities": []
, &"description": "Orcs are fearsome warriors known for their brute strength and relentless aggression. They thrive in battle, often overpowering their foes with sheer force and determination. While they lack finesse, their loyalty to their clan and ferocity make them a dangerous presence on the battlefield.", &"brief_description": "", &"faction": 8, &"unit_type": 4, &"unit_class": 0, &"needed_xp": 400, &"attacks": [{
 &"attack_name": "Attack", &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 0, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 30, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_melee_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
  
}, &"animation_index": 0, &"alternative_actions": []
 
}]
, &"effects": []
, &"base_damage": 45, &"max_hp": 150, &"armor": 10, &"evasion": 0.05, &"shielding_chance": 0.7, &"portrait_texture_path": "res://Arts/Placeholders/Orc.jpg", &"custom_levelup_path": "", &"hero_abilities": "", &"map_effects": {
  
}, &"cost": {
 &"gold": 0, &"stone": 0, &"mana": 0 
} 
},&"Orc chieftain" : {
 &"scene_path": "res://Combat/Units/Derived units//Neutral/orc_chieftain.tscn", &"level": 4, &"large_unit": false, &"immunities": []
, &"description": "Orc Chieftains are the leaders of their clans, commanding respect through strength and cunning. They inspire their kin with battle cries and powerful strikes, rallying their forces to victory.", &"brief_description": "", &"faction": 8, &"unit_type": 4, &"unit_class": 0, &"needed_xp": 1600, &"attacks": [{
 &"attack_name": "Attack", &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 0, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 40, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_melee_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
  
}, &"animation_index": 0, &"alternative_actions": []
 
}]
, &"effects": []
, &"base_damage": 80, &"max_hp": 275, &"armor": 35, &"evasion": 0.05, &"shielding_chance": 0.7, &"portrait_texture_path": "res://Arts/Placeholders/Orc chieftain.jpg", &"custom_levelup_path": "", &"hero_abilities": "", &"map_effects": {
  
}, &"cost": {
 &"gold": 0, &"stone": 0, &"mana": 0 
} 
},&"Goblin" : {
 &"scene_path": "res://Combat/Units/Derived units//Neutral/goblin.tscn", &"level": 1, &"large_unit": false, &"immunities": []
, &"description": "Goblin Archers are small but surprisingly deadly, using their agility to stay out of reach while raining arrows on their enemies. Though their aim can be erratic, their sheer numbers often compensate for individual accuracy. They are often deployed as harassers, chipping away at enemy forces from a safe distance.", &"brief_description": "", &"faction": 8, &"unit_type": 1, &"unit_class": 0, &"needed_xp": 1, &"attacks": [{
 &"attack_name": "Attack", &"damage_multiplier": 0.667, &"damage_override": false, &"is_heal": false, &"type": 0, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 40, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_archer_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
  
}, &"animation_index": 0, &"alternative_actions": []
 
}, {
 &"attack_name": "Attack", &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 0, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 40, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_archer_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
  
}, &"animation_index": 0, &"alternative_actions": []
 
}]
, &"effects": []
, &"base_damage": 30, &"max_hp": 100, &"armor": 0, &"evasion": 0.1, &"shielding_chance": 0.7, &"portrait_texture_path": "res://Arts/Placeholders/Goblin.jpg", &"custom_levelup_path": "", &"hero_abilities": "", &"map_effects": {
  
}, &"cost": {
 &"gold": 0, &"stone": 0, &"mana": 0 
} 
},&"Ogre" : {
 &"scene_path": "res://Combat/Units/Derived units//Neutral/ogre.tscn", &"level": 2, &"large_unit": true, &"immunities": []
, &"description": "Ogres are hulking brutes with unparalleled physical power, smashing through enemies and obstacles alike. Though not known for their intelligence, their immense strength and resilience make them formidable foes. These behemoths are often used as shock troops, devastating enemy ranks with crushing blows.", &"brief_description": "", &"faction": 8, &"unit_type": 4, &"unit_class": 0, &"needed_xp": 400, &"attacks": [{
 &"attack_name": "Attack", &"damage_multiplier": 0.5, &"damage_override": false, &"is_heal": false, &"type": 0, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 15, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_melee_validity.tres", &"additional_targets": "res://Combat/Units/Parameters/Additional targets/Double_attack.tres", &"damage_policy": "", &"applying_effects": {
  
}, &"animation_index": 0, &"alternative_actions": []
 
}]
, &"effects": []
, &"base_damage": 130, &"max_hp": 450, &"armor": 30, &"evasion": 0.01, &"shielding_chance": 0.7, &"portrait_texture_path": "res://Arts/Placeholders/Ogre.jpg", &"custom_levelup_path": "", &"hero_abilities": "", &"map_effects": {
  
}, &"cost": {
 &"gold": 0, &"stone": 0, &"mana": 0 
} 
},&"Thief" : {
 &"scene_path": "res://Combat/Units/Derived units//Neutral/thief.tscn", &"level": 1, &"large_unit": false, &"immunities": []
, &"description": "Thieves are nimble and cunning, excelling in stealth and precision strikes. They specialize in exploiting enemy weaknesses, targeting vulnerabilities for devastating effect.", &"brief_description": "", &"faction": 1, &"unit_type": 4, &"unit_class": 0, &"needed_xp": 1, &"attacks": [{
 &"attack_name": "Attack", &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 0, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 65, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_melee_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
  
}, &"animation_index": 0, &"alternative_actions": []
 
}, {
 &"attack_name": "Attack", &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 0, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 30, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_melee_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
  
}, &"animation_index": 0, &"alternative_actions": []
 
}]
, &"effects": []
, &"base_damage": 25, &"max_hp": 100, &"armor": 0, &"evasion": 0.05, &"shielding_chance": 0.7, &"portrait_texture_path": "res://Arts/Placeholders/Thief.jpg", &"custom_levelup_path": "", &"hero_abilities": "", &"map_effects": {
  
}, &"cost": {
 &"gold": 0, &"stone": 0, &"mana": 0 
} 
},&"Pirate" : {
 &"scene_path": "res://Combat/Units/Derived units//Neutral/pirate.tscn", &"level": 3, &"large_unit": false, &"immunities": []
, &"description": "Pirates are rowdy and fearless, driven by a lust for gold and adventure. Armed with an array of mismatched weapons, they thrive in chaotic battles where their opportunistic nature shines. Their unpredictability and savage fighting style make them a force to be reckoned with.", &"brief_description": "", &"faction": 6, &"unit_type": 4, &"unit_class": 0, &"needed_xp": 900, &"attacks": [{
 &"attack_name": "Attack", &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 0, &"accuracy": 0.95, &"targets_needed": 2, &"initiative": 40, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_melee_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
  
}, &"animation_index": 0, &"alternative_actions": []
 
}]
, &"effects": []
, &"base_damage": 75, &"max_hp": 180, &"armor": 10, &"evasion": 0.08, &"shielding_chance": 0.0, &"portrait_texture_path": "res://Arts/Placeholders/Pirate.jpg", &"custom_levelup_path": "", &"hero_abilities": "", &"map_effects": {
  
}, &"cost": {
 &"gold": 0, &"stone": 0, &"mana": 0 
} 
},&"Rogue" : {
 &"scene_path": "res://Combat/Units/Derived units//Neutral/rogue.tscn", &"level": 2, &"large_unit": false, &"immunities": []
, &"description": "Rogues are seasoned fighters who blend agility and combat prowess, striking quickly and decisively. They are masters of deception, often using dirty tricks to gain the upper hand. Though they prefer to avoid direct confrontation, their versatility makes them a dangerous adversary.", &"brief_description": "", &"faction": 7, &"unit_type": 4, &"unit_class": 0, &"needed_xp": 400, &"attacks": [{
 &"attack_name": "Attack", &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 0, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 60, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_melee_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
 "poison": [10, 3]
 
}, &"animation_index": 0, &"alternative_actions": []
 
}, {
 &"attack_name": "Attack", &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 0, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 45, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_melee_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
 "poison": [10, 3]
 
}, &"animation_index": 0, &"alternative_actions": []
 
}, {
 &"attack_name": "Attack", &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 0, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 30, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_melee_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
 "poison": [10, 3]
 
}, &"animation_index": 0, &"alternative_actions": []
 
}]
, &"effects": []
, &"base_damage": 30, &"max_hp": 150, &"armor": 0, &"evasion": 0.05, &"shielding_chance": 0.7, &"portrait_texture_path": "res://Arts/Placeholders/Rogue.jpg", &"custom_levelup_path": "", &"hero_abilities": "", &"map_effects": {
  
}, &"cost": {
 &"gold": 0, &"stone": 0, &"mana": 0 
} 
},&"Goblin shaman" : {
 &"scene_path": "res://Combat/Units/Derived units//Neutral/goblin_shaman.tscn", &"level": 2, &"large_unit": false, &"immunities": []
, &"description": "Goblin Shamans wield primitive but potent magic, channeling the chaotic energy of their tribe’s spirit rituals. They serve as both support and disruptors, casting spells that weaken enemies or bolster their allies.", &"brief_description": "", &"faction": 8, &"unit_type": 2, &"unit_class": 0, &"needed_xp": 400, &"attacks": [{
 &"attack_name": "Attack", &"damage_multiplier": 0.35, &"damage_override": false, &"is_heal": false, &"type": 1, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 15, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_mage_validity.tres", &"additional_targets": "res://Combat/Units/Parameters/Additional targets/standard_mage_targets.tres", &"damage_policy": "", &"applying_effects": {
  
}, &"animation_index": 0, &"alternative_actions": []
 
}]
, &"effects": []
, &"base_damage": 45, &"max_hp": 75, &"armor": 10, &"evasion": 0.1, &"shielding_chance": 0.7, &"portrait_texture_path": "res://Arts/Placeholders/Goblin shaman.jpg", &"custom_levelup_path": "", &"hero_abilities": "", &"map_effects": {
  
}, &"cost": {
 &"gold": 0, &"stone": 0, &"mana": 0 
} 
},&"Robber" : {
 &"scene_path": "res://Combat/Units/Derived units//Neutral/robber.tscn", &"level": 2, &"large_unit": false, &"immunities": []
, &"description": "", &"brief_description": "", &"faction": 7, &"unit_type": 4, &"unit_class": 0, &"needed_xp": 400, &"attacks": [{
 &"attack_name": "Attack", &"damage_multiplier": 1.0, &"damage_override": false, &"is_heal": false, &"type": 0, &"accuracy": 0.95, &"targets_needed": 1, &"initiative": 0, &"evadable": true, &"tags": []
, &"target_validation": "res://Combat/Units/Parameters/Validation/standard_melee_validity.tres", &"additional_targets": "", &"damage_policy": "", &"applying_effects": {
  
}, &"animation_index": 0, &"alternative_actions": []
 
}]
, &"effects": []
, &"base_damage": 30, &"max_hp": 100, &"armor": 0, &"evasion": 0.05, &"shielding_chance": 0.7, &"portrait_texture_path": "", &"custom_levelup_path": "", &"hero_abilities": "", &"map_effects": {
  
}, &"cost": {
 &"gold": 0, &"stone": 0, &"mana": 0 
} 
},
# end of database
}
