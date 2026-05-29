class_name HeroData
extends UnitData

@export var leading_party: MapParty

## Hero ability tree associated with this unit. [br]
## Has no effect unless this unit is a [HeroData] instance.
@export var hero_levelup: HeroAbilitiesTree = null

func level_up() -> void:
	hero_levelup.levelup()
