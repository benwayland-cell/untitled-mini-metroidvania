extends Level


@onready var tutorial_label: Label = %TutorialLabel
@onready var sword_upgrade = %SwordUpgrade

const MOVEMENT_TEXT := "< > Move"
const JUMP_TEXT := "Z Jump"
const SLASH_TEXT := "X Slash"


enum Tutorial {NONE, MOVEMENT, JUMP, WAIT_FOR_ATTACK, ATTACK}
var current_tutorial: Tutorial


func _ready() -> void:
	super._ready()
	tutorial_label.text = MOVEMENT_TEXT
	current_tutorial = Tutorial.MOVEMENT


func _process(delta: float) -> void:
	super._process(delta)
	
	match current_tutorial:
		Tutorial.MOVEMENT:
			if (Input.is_action_just_pressed("left")
					or Input.is_action_just_pressed("right")):
				tutorial_label.text = JUMP_TEXT
				current_tutorial = Tutorial.JUMP
		
		Tutorial.JUMP:
			if Input.is_action_just_pressed("jump"):
				tutorial_label.text = ""
				current_tutorial = Tutorial.WAIT_FOR_ATTACK
		
		Tutorial.WAIT_FOR_ATTACK:
			# if sword_upgrade was freed
			if not is_instance_valid(sword_upgrade):
				tutorial_label.text = SLASH_TEXT
				current_tutorial = Tutorial.ATTACK
		
		Tutorial.ATTACK:
			if Input.is_action_just_pressed("attack"):
				tutorial_label.text = ""
				current_tutorial = Tutorial.NONE
