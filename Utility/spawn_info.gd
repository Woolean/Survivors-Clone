extends Resource

class_name Spawn_info

@export var time_start:int #cuando spawnea
@export var time_end:int #cuando spawnea
@export var enemy:Resource #qué enemigo spawnea
@export var enemy_num:int #cantidad de enemigos
@export var enemy_spawn_delay:int #tiempo entre spawns

var spawn_delay_counter = 0 #lleva el tiempo entre spawns en segundos 
