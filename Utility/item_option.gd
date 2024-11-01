extends TextureRect

var item = null
@onready var player = get_tree().get_first_node_in_group("Player")
@onready var button: Button = $Button
@onready var itemIcon: TextureRect = $TextureRect
@onready var lbl_name = $lbl_name
@onready var lbl_description = $lbl_description
@onready var lbl_level = $lbl_level

signal selected_upgrade(upgrade)
signal click_end()

func _ready():
	assert(selected_upgrade.connect(player.upgrade_character) == OK)
	assert(button.pressed.connect(click) == OK)
	
	if item == null:
		item = "food"
	
	lbl_name.text = UpgradeDb.UPGRADES[item]["displayname"]
	lbl_description.text = UpgradeDb.UPGRADES[item]["details"]
	lbl_level.text = UpgradeDb.UPGRADES[item]["level"]
	itemIcon.texture = load(UpgradeDb.UPGRADES[item]["icon"])

func click() -> void:
	selected_upgrade.emit(item)


func _on_snd_click_finished() -> void:
	emit_signal("click_end")

func _on_button_mouse_entered() -> void:
	$snd_hover.play()


func _on_button_pressed() -> void:
	$snd_click.play()
