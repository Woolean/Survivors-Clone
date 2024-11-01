extends TextureRect

var upgrade = null
@onready var item_texture: TextureRect = $ItemTexture
@onready var color_rect: ColorRect = $ColorRect
@onready var label: Label = $ColorRect/Label

func _ready() -> void:
	if upgrade != null:
		item_texture.texture = load(UpgradeDb.UPGRADES[upgrade]["icon"])
		label.text = str(UpgradeDb.UPGRADES[upgrade]["details"])


func _on_mouse_entered() -> void:
	color_rect.show()

func _on_mouse_exited() -> void:
	color_rect.hide()
