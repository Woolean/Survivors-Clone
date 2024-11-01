extends CharacterBody2D

var movement_speed = 100.0
var hp = 101
var maxhp = 100
var last_movement = Vector2.UP
var pass_time = 0
var is_dead = false

var experience = 0
var experience_level = 1
var collected_experience = 0

#attacks
var dynamite = preload("res://Player/Attack/dynamite.tscn")
var barrel = preload("res://Player/Attack/barrel.tscn")
var sheep = preload("res://Player/Attack/sheep.tscn")

#attackNodes
@onready var dynamiteTimer = get_node("%DynamiteTimer")
@onready var dynamiteAttackTimer: Timer = get_node("%DynamiteAttackTimer")
@onready var barrelTimer = get_node("%BarrelTimer")
@onready var barrelAttackTimer = get_node("%BarrelAttackTimer")
@onready var sheepBase = get_node("%SheepBase")

#UPGRADES
var collected_upgrades = []
var upgrade_selection = []
var armor = 0
var speed = 0
var spell_cooldown = 0
var spell_size = 0
var additional_attacks = 0

#Dynamite
var dynamite_ammo = 0
var dynamite_baseammo = 0
var dynamite_attackspeed = 3.5
var dynamite_level = 1

#Barrel
var barrel_ammo = 0
var barrel_baseammo = 0
var barrel_attackspeed = 5
var barrel_level = 1

#Sheep
var sheep_ammo = 0
var sheep_level = 0

#Enemy Related
var enemy_close = []
var enemy_count = 0

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

#GUI
@onready var expBar = get_node("%ExperienceBar")
@onready var lblLevel = get_node("%Lbl_level")
@onready var levelPanel = get_node("%LevelUp")
@onready var upgradeOptions = get_node("%UpgradeOptions")
@onready var sndLevelUp = get_node("%snd_LevelUp")
@onready var itemOptions = preload("res://Utility/item_option.tscn")
@onready var lblTimer = get_node("%lblTimer")
@onready var healthBar = get_node("%HealthBar")
@onready var lbl_health = get_node("%Lbl_health")
@onready var collectedWeapons = get_node("%CollectedWeapons")
@onready var collectedUpgrades = get_node("%CollectedUpgrades")
@onready var itemContainer = preload("res://Player/item_container.tscn")
@onready var deathPanel = get_node("%DeathPanel")
@onready var lblResult = get_node("%Lbl_Result")
@onready var lblResultInfo = get_node("%Lbl_info")
@onready var sndVictory = get_node("%snd_victory")
@onready var sndLose = get_node("%snd_lose")

#signal
signal playerdeath


func _ready():
	upgrade_character("dynamite1")
	attack()
	set_expbar(experience, calculate_experience_cap())
	_on_hurt_box_hurt(0, 0, 0)
	animated_sprite_2d.modulate = Color(1,1,1)

func _physics_process(delta: float) -> void:
	if !is_dead:
		movement()
	pass_time += delta
	change_time()

func attack():
	if dynamite_level > 0:
		dynamiteTimer.wait_time = dynamite_attackspeed * (1-spell_cooldown)
		if dynamiteTimer.is_stopped():
			dynamiteTimer.start()
	if barrel_level > 0:
		barrelTimer.wait_time = barrel_attackspeed * (1-spell_cooldown)
		if barrelTimer.is_stopped():
			barrelTimer.start()
	if sheep_level > 0:
		spawn_sheep()

func movement():
	var x_mov = Input.get_action_strength("right") - Input.get_action_strength("left")
	var y_mov = Input.get_action_strength("down") - Input.get_action_strength("up")
	var mov = Vector2(x_mov, y_mov)
	velocity = mov.normalized()*movement_speed
	
	if !animated_sprite_2d.is_playing():
		if velocity.is_zero_approx(): #Cambio de animación cuando el personaje se mueve
			animated_sprite_2d.play("idle")
		else:
			animated_sprite_2d.play("run")
	
	if x_mov > 0: #Cambia la dirección del personaje segun hacia donde vaya
		animated_sprite_2d.flip_h = false
	elif x_mov < 0:
		animated_sprite_2d.flip_h = true
	
	if mov != Vector2.ZERO:
		last_movement = mov
	
	move_and_slide()

func death():
	animated_sprite_2d.play("dead")
	is_dead = true
	await get_tree().create_timer(1.4).timeout
	if !animated_sprite_2d.is_playing():
		deathPanel.visible = true
		emit_signal("playerdeath")
		get_tree().paused = true
		var tween = deathPanel.create_tween()
		tween.tween_property(deathPanel, "position", Vector2(600, 200), 0.2).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
		tween.play()
		if pass_time >= 300:
			lblResult.text = "You Survived Long Enough to Become a Legend"
			lblResultInfo.text = str("Level: ", experience_level, "\nEnemies Killed: "
			, enemy_count)
			sndVictory.play()
		else:
			lblResult.text = "You're a dead Goblin, Forgotten by All"
			lblResultInfo.text = str("Level: ", experience_level, "\nEnemies Killed: "
			, enemy_count)
			sndLose.play()
	

func _on_hurt_box_hurt(damage: Variant, _angle, _knockback) -> void:
	hp -= clamp(damage-armor, 1.0, 999.0)
	animated_sprite_2d.modulate = Color.html("#F76666")
	#collision_shape_2d.call_deferred("set","disabled",true)
	await get_tree().create_timer(1.0).timeout
	animated_sprite_2d.modulate = Color(1,1,1)
	#collision_shape_2d.call_deferred("set","disabled",false)
	healthBar.max_value = maxhp
	healthBar.value = hp
	lbl_health.text = str(hp,"/",maxhp) 
	if hp <= 0:
		death()

func spawn_sheep():
	var get_sheep_total = sheepBase.get_child_count()
	var calc_spawns = (sheep_ammo + additional_attacks) - get_sheep_total
	while calc_spawns > 0:
		var sheep_spawn = sheep.instantiate()
		sheep_spawn.global_position = global_position
		sheepBase.add_child(sheep_spawn)
		calc_spawns -= 1
	#update sheep
	var get_sheep = sheepBase.get_children()
	for i in get_sheep:
		if i.has_method("update_sheep"):
			i.update_sheep()

func _on_dynamite_timer_timeout() -> void:
	if dynamite_baseammo > 0:
		dynamite_ammo += dynamite_baseammo + additional_attacks
	dynamiteAttackTimer.start()

func _on_dynamite_attack_timer_timeout() -> void:
	if !is_dead:
		if dynamite_ammo > 0:
			var dynamite_attack = dynamite.instantiate()
			dynamite_attack.position = position
			dynamite_attack.target = get_random_target()
			dynamite_attack.level = dynamite_level
			add_child(dynamite_attack)
			animated_sprite_2d.play("throw")
			dynamite_ammo -= 1
			if dynamite_ammo > 0:
				dynamiteAttackTimer.start()
			else:
				dynamiteAttackTimer.stop()
				
				
func get_random_target():
	if enemy_close.size() > 0:
		#return get_closest_enemy(global_position, enemy_close).global_position
		return enemy_close.pick_random().global_position
	else:
		return Vector2.UP

func get_closest_enemy(current_position: Vector2, enemies):
	var closest_enemy = null
	var closest_distance:float = 1e20  # Initialize with a large number
	
	for enemy in enemies:
		var distance = current_position.distance_to(enemy.global_position)
		if distance < closest_distance:
			closest_distance = distance
			closest_enemy = enemy
	return closest_enemy

func _on_enemy_detection_area_body_entered(body: Node2D) -> void:
	if not enemy_close.has(body):
		enemy_close.append(body)

func _on_enemy_detection_area_body_exited(body: Node2D) -> void:
	if enemy_close.has(body):
		enemy_close.erase(body)
		

func _on_barrel_timer_timeout() -> void:
	if barrel_baseammo > 0:
		barrel_ammo += barrel_baseammo + additional_attacks
	barrelAttackTimer.start()

func _on_barrel_attack_timer_timeout() -> void:
	if !is_dead:
		if barrel_ammo > 0:
			var barrel_attack = barrel.instantiate()
			barrel_attack.position = position
			barrel_attack.last_movement = last_movement
			barrel_attack.level = barrel_level
			add_child(barrel_attack)
			barrel_ammo -= 1
			if barrel_ammo > 0:
				barrelAttackTimer.start()
			else:
				barrelAttackTimer.stop()

func _on_grab_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("loot"):
		area.target = self

func _on_collect_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("loot"):
		var gem_exp = area.collect()
		calculate_experience(gem_exp)
		
func calculate_experience(gem_exp):
	var exp_required = calculate_experience_cap()
	collected_experience += gem_exp
	if experience + collected_experience >= exp_required:
		collected_experience -= exp_required-experience
		experience_level += 1
		experience = 0
		exp_required = calculate_experience_cap()
		levelUp()
	else:
		experience += collected_experience
		collected_experience = 0
		
	set_expbar(experience, exp_required)
	
func calculate_experience_cap():
	var exp_cap = experience_level
	if experience_level < 20:
		exp_cap = experience_level*5
	elif experience_level < 40:
		exp_cap = 95 + (experience_level - 19) * 8
	else:
		exp_cap = 255 + (experience_level - 39) * 12
	
	return exp_cap

func set_expbar(set_value = 1, set_max_value = 100):
	expBar.value = set_value
	expBar.max_value = set_max_value

func levelUp():
	sndLevelUp.play()
	lblLevel.text = str("Level: ", experience_level)
	var tween = levelPanel.create_tween()
	tween.tween_property(levelPanel, "position", Vector2(600, 200), 0.2).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN)
	tween.play()
	levelPanel.visible = true
	var options = 0
	var optionsMax = 3
	
	while options < optionsMax:
		var option_choice = itemOptions.instantiate()
		option_choice.item = get_random_item()
		upgradeOptions.add_child(option_choice)
		options += 1
		
	get_tree().paused = true

func upgrade_character(upgrade):
	match upgrade:
		"dynamite1":
			dynamite_level = 1
			dynamite_baseammo += 1
		"dynamite2":
			dynamite_level = 2
			dynamite_baseammo += 1
		"dynamite3":
			dynamite_level = 3
		"dynamite4":
			dynamite_level = 4
			dynamite_baseammo += 2
		"berserk1":
			barrel_level = 1
			barrel_baseammo += 1
		"berserk2":
			barrel_level = 2
			barrel_baseammo += 1
		"berserk3":
			barrel_level = 3
			barrel_attackspeed -= 0.5
		"berserk4":
			barrel_level = 4
			barrel_baseammo += 1
		"sheep1":
			sheep_level = 1
			sheep_ammo = 1
		"sheep2":
			sheep_level = 2
		"sheep3":
			sheep_level = 3
		"sheep4":
			sheep_level = 4
		"armor1","armor2","armor3","armor4":
			armor += 1
		"speed1","speed2","speed3","speed4":
			movement_speed += 40.0
		"tome1","tome2","tome3","tome4":
			spell_size += 0.10
		"scroll1","scroll2","scroll3","scroll4":
			spell_cooldown += 0.05
		"mushroom1","mushroom2":
			additional_attacks += 1
		"food":
			hp += 21
			hp = clamp(hp,0,maxhp)
			_on_hurt_box_hurt(0,0,0)
		"pumpkin":
			maxhp += 5
			healthBar.max_value += 5
			lbl_health.text = str(hp,"/",maxhp) 
	adjust_gui_collection(upgrade)
	attack()
	var option_children = upgradeOptions.get_children()
	for i in option_children:
		i.queue_free()
	upgrade_selection.clear()
	collected_upgrades.append(upgrade)
	levelPanel.visible = false
	levelPanel.position = Vector2(1914, 250)
	get_tree().paused = false
	calculate_experience(0)

func get_random_item():
	var dblist = []
	for i in UpgradeDb.UPGRADES:
		if i in collected_upgrades: #encontrar upgrades ya usados
			pass
		elif i in upgrade_selection: #si el upgrade ya es una opcion
			pass
		elif UpgradeDb.UPGRADES[i]["type"] == "culo": #skipear upgrade que ya tocó
			pass
		elif UpgradeDb.UPGRADES[i]["prerequisite"].size() > 0: #check for prerequisites
			var to_add = true
			for n in UpgradeDb.UPGRADES[i]["prerequisite"]:
				if not n in collected_upgrades:
					to_add = false
			if to_add:
				dblist.append(i)
		else:
			dblist.append(i)
	if dblist.size() > 0:
		var randomitem = dblist.pick_random()
		upgrade_selection.append(randomitem)
		return randomitem
	else:
		return null

func change_time(argtime=0):
	var time = int(pass_time)
	var m = int(time / 60.0)
	var s = time % 60
	if m < 10:
		m = str(0, m)
	if s < 10:
		s = str(0, s)
		
	lblTimer.text = str(m, ":", s)

func adjust_gui_collection(upgrade):
	var get_upgraded_displayname = UpgradeDb.UPGRADES[upgrade]["displayname"]
	var get_type = UpgradeDb.UPGRADES[upgrade]["type"]
	if get_type != "item":
		var get_collected_displaynames = []
		for i in collected_upgrades:
			get_collected_displaynames.append(UpgradeDb.UPGRADES[i]["displayname"])
		if not get_upgraded_displayname in get_collected_displaynames:
			var new_item = itemContainer.instantiate()
			new_item.upgrade = upgrade
			match get_type:
				"weapon":
					collectedWeapons.add_child(new_item)
				"upgrade":
					collectedUpgrades.add_child(new_item)

func _on_btn_menu_click_end() -> void:
	get_tree().paused = false
	var _level = get_tree().change_scene_to_file("res://World/menu.tscn")


func _on_enemy_detection_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("loot"):
		enemy_count += 1
