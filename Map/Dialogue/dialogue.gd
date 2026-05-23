class_name DialogueNode
extends Resource

## Represents a single dialogue entry in a branching conversation tree.
##
## The dialogue structure is stored as a tree using the [member options] dictionary.
## Each key is a dialogue choice presented to the player, and its value is the
## next [DialogueNode] that follows that choice. This object can also interface
## with the event system to trigger side effects or modify in-game variables.

## If [code]false[/code], the player cannot skip this dialogue line.
## From a game design perspective, this should be used sparingly, as many 
## players prefer to have the ability to skip dialogue at their own pace.
@export var skippable := true

## The name of the speaker
@export var speaker := ""

## The main text of this dialogue entry.
@export_multiline var text: String

## Path to the portrait image file used for this dialogue node.
## Has no effect if [member dynamic_portrait] is [code]true[/code] or
## if [member portrait_position] is [member PortraitPosition.Unchanged]
@export var portrait_path: String

## When [code]true[/code], this dialogue node does not load the texture from
## [member portrait_path]. Instead, the texture is expected to be set
## externally by the calling script and is not managed automatically.
@export var dynamic_portrait := false

## Controls the placement of the portrait during this dialogue line.
@export var portrait_position: PortraitPosition = PortraitPosition.AutoOpposite

## When not empty, selecting this dialogue option emits
## [signal EventBus.dialogue_id_selected], which activates the associated
## [MapTrigger_OnDialogueChoice] trigger(s).
@export var dialogue_id := &""

## A dictionary mapping player‑visible dialogue options to the next dialogue node.
## A value of [code]null[/code] indicates the end of the dialogue branch.
## If the dictionary is empty, a default [i]"End dialogue."[/i] 
## option will be shown in the player's UI.
@export var options: Dictionary[String, DialogueNode]

enum PortraitPosition {
	## Automatically chooses left or right based on the previous message's position,
	## switching to the opposite side.
	AutoOpposite,
	## Keep the same side as the previous message (portrait may change,
	## but its orientation stays the same).
	AutoSame,
	## Force the message to appear on the left side (portrait on the left, facing right).
	Left,
	## Force the message to appear on the right side (portrait on the right, facing left).
	Right,
	## Keep the exact same portrait and position as the previous message.
	Unchanged,
}
