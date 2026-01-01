class_name MapResourceContainer
extends Node

## Public getter for faction gold reserves.
## To change the amount, use [method spend_gold] or similar,
## do not access the underlying value directly.
var gold: int:
	get: return _gold
var _gold: int = 3:
	get: return _gold
	set(value):
		if value == _gold: return
		_gold = value
		reserve_updated.emit()

## Public getter for faction stone reserves.
## To change the amount, use [method spend_stone] or similar,
## do not access the underlying value directly.
var stone: int:
	get: return _stone
var _stone: int = 0:
	get: return _stone
	set(value):
		if value == _stone: return
		_stone = value
		reserve_updated.emit()

## Public getter for faction mana reserves.
## To change the amount, use [method spend_mana] or similar,
## do not access the underlying value directly.
var mana: int = 0:
	get: return _mana
var _mana: int = 0:
	get: return _mana
	set(value):
		if value == _mana: return
		_mana = value
		reserve_updated.emit()

signal reserve_updated

## Attempts to deduct [param amount] from faction gold reserves.
## Returns [code]true[/code] if sufficient resource was available and deducted.
func spend_gold(amount: int) -> bool:
	if amount < 0: return false
	if amount > gold:
		return false
	_gold -= amount
	return true

## Attempts to deduct [param amount] from faction stone reserves.
## Returns [code]true[/code] if sufficient resource was available and deducted.
func spend_stone(amount: int) -> bool:
	if amount < 0: return false
	if amount > stone:
		return false
	_stone -= amount
	return true

## Attempts to deduct [param amount] from faction mana reserves.
## Returns [code]true[/code] if sufficient resource was available and deducted.
func spend_mana(amount: int) -> bool:
	if amount < 0: return false
	if amount > mana:
		return false
	_mana -= amount
	return true

func can_spend(amount: ResourceCost) -> bool:
	return \
		amount.gold <= gold and \
		amount.stone <= stone and \
		amount.mana <= mana

func spend(amount: ResourceCost) -> bool:
	if not can_spend(amount): return false
	spend_gold(amount.gold)
	spend_stone(amount.stone)
	spend_mana(amount.mana)
	return true
