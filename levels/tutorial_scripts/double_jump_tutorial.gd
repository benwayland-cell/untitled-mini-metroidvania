extends Level

@onready var slime_with_upgrade: Enemy = %BasicSlime
@onready var enemies_node: Node = %Enemies
@onready var tutorial_label: Label = %TutorialLabel

var tutorial_end: bool = false


func _ready() -> void:
	super._ready()
	slime_with_upgrade.died.connect(_on_slime_died)


func _on_slime_died() -> void:
	for child in enemies_node.get_children():
		if child is UpgradeClass:
			child.collected.connect(_on_upgrade_collected)
			return


func _on_upgrade_collected() -> void:
	tutorial_label.show()


func _process(delta: float) -> void:
	super._process(delta)
	
	if tutorial_end:
		return
	
	if tutorial_label.visible and player.position.x >= 0:
		tutorial_label.hide()
		tutorial_end = true
