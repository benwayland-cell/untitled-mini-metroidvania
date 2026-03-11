extends Level


@onready var tutorial_label: Label = %TutorialLabel
@export var dash_ability: UpgradeClass

var finished_tutorial: bool = false


func _ready() -> void:
	super._ready()
	assert(dash_ability != null, "Forgot to export the dash ability for the dash tutorial")


func _process(delta: float) -> void:
	super._process(delta)
	
	if not is_instance_valid(dash_ability) and not finished_tutorial:
		tutorial_label.show()
		
		if Input.is_action_just_pressed("dash"):
			tutorial_label.hide()
			finished_tutorial = true
