extends Node

const ICON_PATH = "res://Textures/Items/Upgrades/Goblins/"
const WEAPON_PATH = "res://Textures/Items/Upgrades/Goblins/Weapons/"

const UPGRADES = {
	"dynamite1": {
		"icon": WEAPON_PATH + "dynamite.png",
		"displayname": "Dynamite",
		"details": "A dynamite is thrown at a random enemy",
		"level": "Level: 1", 
		"prerequisite": [],
		"type": "weapon"
	},
	"dynamite2": {
		"icon": WEAPON_PATH + "dynamite.png",
		"displayname": "Dynamite",
		"details": "An additional dynamite is thrown",
		"level": "Level: 2", 
		"prerequisite": ["dynamite1"],
		"type": "weapon"
	},
	"dynamite3": {
		"icon": WEAPON_PATH + "dynamite.png",
		"displayname": "Dynamite",
		"details": "Dynamite now pass through another enemy and has +3 damage",
		"level": "Level: 3",
		"prerequisite": ["dynamite2"],
		"type": "weapon"
	},
	"dynamite4": {
		"icon": WEAPON_PATH + "dynamite.png",
		"displayname": "Dynamite",
		"details": "2 additional Dynamite are thrown",
		"level": "Level: 4",
		"prerequisite": ["dynamite3"],
		"type": "weapon"
	},
	"sheep1": {
		"icon": WEAPON_PATH + "sheep.png",
		"displayname": "Sheep",
		"details": "A sheep will follow you attacking enemies in a straight line",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "weapon"
	},
	"sheep2": {
		"icon": WEAPON_PATH + "sheep.png",
		"displayname": "Sheep",
		"details": "The sheep will now attack an additional enemy per attack",
		"level": "Level: 2",
		"prerequisite": ["sheep1"],
		"type": "weapon"
	},
	"sheep3": {
		"icon": WEAPON_PATH + "sheep.png",
		"displayname": "Sheep",
		"details": "The sheep will attack another additional enemy per attack",
		"level": "Level: 3",
		"prerequisite": ["sheep2"],
		"type": "weapon"
	},
	"sheep4": {
		"icon": WEAPON_PATH + "sheep.png",
		"displayname": "Sheep",
		"details": "The sheep now does +5 damage per attack and causes +20% knockback",
		"level": "Level: 4",
		"prerequisite": ["sheep3"],
		"type": "weapon"
	},
	"berserk1": {
		"icon": WEAPON_PATH + "barrel.png",
		"displayname": "Berserk",
		"details": "A berserk is created that burns everything in the players direction",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "weapon"
	},
	"berserk2": {
		"icon": WEAPON_PATH + "barrel.png",
		"displayname": "Berserk",
		"details": "An additional Berserk is created",
		"level": "Level: 2",
		"prerequisite": ["berserk1"],
		"type": "weapon"
	},
	"berserk3": {
		"icon": WEAPON_PATH + "barrel.png",
		"displayname": "Berserk",
		"details": "The Berserk cooldown is reduced by 0.5 seconds",
		"level": "Level: 3",
		"prerequisite": ["berserk2"],
		"type": "weapon"
	},
	"berserk4": {
		"icon": WEAPON_PATH + "barrel.png",
		"displayname": "Berserk",
		"details": "An additional Berserk is created and the knockback is increased by 25%",
		"level": "Level: 4",
		"prerequisite": ["berserk3"],
		"type": "weapon"
	},
	"armor1": {
		"icon": ICON_PATH + "helmet_1.png",
		"displayname": "Armor",
		"details": "Reduces Damage By 1 point",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "upgrade"
	},
	"armor2": {
		"icon": ICON_PATH + "helmet_1.png",
		"displayname": "Armor",
		"details": "Reduces Damage By 1 point",
		"level": "Level: 2",
		"prerequisite": ["armor1"],
		"type": "upgrade"
	},
	"armor3": {
		"icon": ICON_PATH + "helmet_1.png",
		"displayname": "Armor",
		"details": "Reduces Damage By 1 point",
		"level": "Level: 3",
		"prerequisite": ["armor2"],
		"type": "upgrade"
	},
	"armor4": {
		"icon": ICON_PATH + "helmet_1.png",
		"displayname": "Armor",
		"details": "Reduces Damage By 1 point",
		"level": "Level: 4",
		"prerequisite": ["armor3"],
		"type": "upgrade"
	},
	"speed1": {
		"icon": ICON_PATH + "boots_4_green.png",
		"displayname": "Speed",
		"details": "+50% to Movement Speed",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "upgrade"
	},
	"speed2": {
		"icon": ICON_PATH + "boots_4_green.png",
		"displayname": "Speed",
		"details": "+50% to Movement Speed",
		"level": "Level: 2",
		"prerequisite": ["speed1"],
		"type": "upgrade"
	},
	"speed3": {
		"icon": ICON_PATH + "boots_4_green.png",
		"displayname": "Speed",
		"details": "+50% to Movement Speed",
		"level": "Level: 3",
		"prerequisite": ["speed2"],
		"type": "upgrade"
	},
	"speed4": {
		"icon": ICON_PATH + "boots_4_green.png",
		"displayname": "Speed",
		"details": "+50% to Movement Speed",
		"level": "Level: 4",
		"prerequisite": ["speed3"],
		"type": "upgrade"
	},
	"tome1": {
		"icon": ICON_PATH + "thick_new.png",
		"displayname": "Tome",
		"details": "+10% size for all Spells",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "upgrade"
	},
	"tome2": {
		"icon": ICON_PATH + "thick_new.png",
		"displayname": "Tome",
		"details": "+10% size for all Spells",
		"level": "Level: 2",
		"prerequisite": ["tome1"],
		"type": "upgrade"
	},
	"tome3": {
		"icon": ICON_PATH + "thick_new.png",
		"displayname": "Tome",
		"details": "+10% size for all Spells",
		"level": "Level: 3",
		"prerequisite": ["tome2"],
		"type": "upgrade"
	},
	"tome4": {
		"icon": ICON_PATH + "thick_new.png",
		"displayname": "Tome",
		"details": "+10% size for all Spells",
		"level": "Level: 4",
		"prerequisite": ["tome3"],
		"type": "upgrade"
	},
	"scroll1": {
		"icon": ICON_PATH + "scroll_old.png",
		"displayname": "Scroll",
		"details": "+5% Cooldown reduction to all Attacks",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "upgrade"
	},
	"scroll2": {
		"icon": ICON_PATH + "scroll_old.png",
		"displayname": "Scroll",
		"details": "+5% Cooldown reduction to all Attacks",
		"level": "Level: 2",
		"prerequisite": ["scroll1"],
		"type": "upgrade"
	},
	"scroll3": {
		"icon": ICON_PATH + "scroll_old.png",
		"displayname": "Scroll",
		"details": "+5% Cooldown reduction to all Attacks",
		"level": "Level: 3",
		"prerequisite": ["scroll2"],
		"type": "upgrade"
	},
	"scroll4": {
		"icon": ICON_PATH + "scroll_old.png",
		"displayname": "Scroll",
		"details": "+5% Cooldown reduction to all Attacks",
		"level": "Level: 4",
		"prerequisite": ["scroll3"],
		"type": "upgrade"
	},
	"mushroom1": {
		"icon": ICON_PATH + "urand_mage.png",
		"displayname": "Mushroom",
		"details": "Your Attacks now spawn an additional attack",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "upgrade"
	},
	"mushroom2": {
		"icon": ICON_PATH + "urand_mage.png",
		"displayname": "Mushroom",
		"details": "Your Attacks now spawn an additional attack",
		"level": "Level: 2",
		"prerequisite": ["mushroom1"],
		"type": "upgrade"
	},
	"food": {
		"icon": ICON_PATH + "meat.png",
		"displayname": "Nice Meal",
		"details": "Heals 20 health",
		"level": "N/A", 
		"prerequisite": [],
		"type": "item"
	},
	"pumpkin":{
		"icon": ICON_PATH + "pumpkin.png",
		"displayname": "Pumpkin",
		"details": "Gain 5 extra health permanently",
		"level": "N/A", 
		"prerequisite": [],
		"type": "upgrade"
	}
}
