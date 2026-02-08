extends Panel

@onready var primary = $PrimaryDropdown
@onready var sidearm = $SidearmDropdown
@onready var utility = $UtilityDropdown
var deployed = false

func _ready() -> void:
	for i in Global.ALLWEAPONS.size():
		for i2 in Global.WEAPONS.size():
			if Global.ALLWEAPONS[i]["class"] == "primary":
				if Global.ALLWEAPONS[i]["id"] == Global.WEAPONS[i2]["id"]:
					primary.add_item(Global.WEAPONS[i2]["name"], Global.ALLWEAPONS[i]["id"])
			if Global.ALLWEAPONS[i]["class"] == "sidearm":
				if Global.ALLWEAPONS[i]["id"] == Global.WEAPONS[i2]["id"]:
					sidearm.add_item(Global.WEAPONS[i2]["name"], Global.ALLWEAPONS[i]["id"])
			if Global.ALLWEAPONS[i]["class"] == "utility":
				if Global.ALLWEAPONS[i]["id"] == Global.WEAPONS[i2]["id"]:
					utility.add_item(Global.WEAPONS[i2]["name"], Global.ALLWEAPONS[i]["id"])	


func _on_equip_button_pressed() -> void:
	Global.EQUIPPED_WEAPONS = []
	Global.SAVED_WEAPONS = []
	for i in Global.WEAPONS.size():
		if utility.get_selected_id() == Global.WEAPONS[i]["id"]:
			Global.EQUIPPED_WEAPONS.append(Global.WEAPONS[i])	
			Global.SAVED_WEAPONS.append(Global.ALLWEAPONS[i])
		if sidearm.get_selected_id() == Global.WEAPONS[i]["id"]:
			Global.EQUIPPED_WEAPONS.append(Global.WEAPONS[i])
			Global.SAVED_WEAPONS.append(Global.ALLWEAPONS[i])
		if primary.get_selected_id() == Global.WEAPONS[i]["id"]:
			Global.EQUIPPED_WEAPONS.append(Global.WEAPONS[i])
			Global.SAVED_WEAPONS.append(Global.ALLWEAPONS[i])
	Global.CONFIG.set_value("items", "weapons", Global.SAVED_WEAPONS)
	Global.CONFIG.save(Global.SAVE_PATH)


func _on_weapons_button_pressed() -> void:
	if !deployed:
		visible = true
		var tween = create_tween()
		tween.tween_property(self, "position", Vector2(421.0, position.y), 0.5).set_trans(Tween.TRANS_QUINT)
		deployed = true
	elif deployed:
		var tween = create_tween()
		tween.tween_property(self, "position", Vector2(161.0, position.y), 0.5).set_trans(Tween.TRANS_QUINT)
		await tween.finished
		visible = false	
		deployed = false



	pass # Replace with function body.
