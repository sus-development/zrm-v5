extends Node2D

var my_aims = []

var my_items = []

const STORAGEITEM = preload("res://storageitem.tscn")

const SAVE_PATH = "user://save.cfg"
var CONFIG = ConfigFile.new()

func _ready() -> void:
	Global.CONFIG.load(SAVE_PATH)
	
	if Global.CONFIG.get_value("items", "aims"):
		my_aims = Global.CONFIG.get_value("items", "aims")
		print("МОИ ПРИЦЕЛЫ (стрелка вниз)")
		print(my_aims)
		
		for aim in my_aims:
			# print(aim)
			var stritem = STORAGEITEM.instantiate()
			stritem.Iicon = str(aim["sprite"])
			stritem.Ititle = str(aim["name"])
			
			$CanvasLayer/ScrollContainer/VBoxContainer/GridContainer.add_child(stritem)
		
		

func _on_quitstorage_pressed() -> void:
	# куда нужно? 🗣️
	get_tree().change_scene_to_file("res://menu.tscn")
