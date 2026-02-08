# TODO
# [1/2] Доделать прицелы
# [*] Сделать кнопки открытия сайта мода в списке модов
# [*] Добавить больше режимов в игру
# [1/4] Доделать магазин и инвентарь (склад)
# [*] Добавить режимы в модлоадер
# [-] Вернуть Discord Rich Preference (или как его) из 1.3 и ниже
# [*] добавьте больше TODO🤪🤪🤪 
# [ ] добавить автомобильный режим
# [ ] сделать ЕЩЁ больше TODO tm

# INFO самые важные песни зр 2.0 это:
# бутырка метеорит

# чтооо годот подсветка комментариев😨
# ALERT, ATTENTION, CAUTION, CRITICAL, DANGER, SECURITY
# BUG, DEPRECATED, FIXME, HACK, TASK, TBD, TODO, WARNING
# INFO, NOTE, NOTICE, TEST, TESTING

extends Node

# Настройки и служебное
var VERSION = ProjectSettings.get_setting("application/config/version")
var FULLSCREEN = false
var SmoothTransitions = false
var WEAPONHINTS = true
@onready var GAME = "res://gamemode.tscn"
@onready var SETTINGS = "res://settings.tscn"
const isDEMO = true # Данная настройка отключает магазин, склад и список модов Онлайн, так-как оно не готово (онлайн моды я ещё апи не сделал ну я и лох вообще)

#Конфиги
const SAVE_PATH = "user://save.cfg"
var CONFIG = ConfigFile.new()
var KT_URL = "https://kteam.veliona.no/"
var WEAPONS = [
		{
		"name": tr("$starterpistol"),
		"delay": 1,
		"automatic": false,
		"bullets": 12,
		"left_bullets": 12,
		"zapas_bullets": 48,
		"icon": "res://Resources/ui_stuff_lol/weapon_starterpistol.png",
		"incremental_reload": false,
		"increment_sound": "res://Sound/shotgun_increment",
		"increment_delay": 0,
		"type": "gun",
		"sway": 0.07,
		"soundondelay": false,
		"delaysound": "res://Sound/shotgun_cycle.wav",
		"sound": "res://Sound/pistol.wav",
	},
]



# Переменные
var BGID
var FROM = 0
var ZCOINS = 0
var CURRENT_AIM = preload("res://Resources/aims/default.png")
var GAYPAD_AIDS = 1 # причем тут aids? ну, типа короче типа я хотел сначала gaypad_speed, ну типа спид, а спид по английски это aids вот типа шутка да хазвъзахвзахвзахвза
var CONTROLLER_CONNECTED = false
var weap_chng_btn

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("fullscreenkey"):
		if FULLSCREEN == false:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			FULLSCREEN = true
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			FULLSCREEN = false
	
func _ready() -> void:
	CONFIG.load(SAVE_PATH)
	if !CONFIG.get_value("settings", "lang"):
		TranslationServer.set_locale("en")
	else:
		TranslationServer.set_locale(CONFIG.get_value("settings", "lang"))
		
	if CONFIG.get_value("settings", "smoothtransitions"):
		SmoothTransitions = CONFIG.get_value("settings", "smoothtransitions")
	
	if CONFIG.get_value("save", "disableweaponhints"):
		WEAPONHINTS = CONFIG.get_value("save", "disableweaponhints")
		
	if CONFIG.get_value("settings", "fullscreen"):
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		FULLSCREEN = CONFIG.get_value("settings", "fullscreen")
		
	if CONFIG.get_value("settings", "gamepad_sens"):
		GAYPAD_AIDS = CONFIG.get_value("settings", "gamepad_sens")
		
	if CONFIG.get_value("save", "zcoins"):
		ZCOINS = CONFIG.get_value("save", "zcoins")
		

		
	# tf2 reference ALERT
	# NOTE: я скомпилированную игру не могу запустить, надо закомментировать rsiughdsugjh
#	if !FileAccess.file_exists("res://_IMPORTANT_IMAGE_DONT_DELETE_INACHE_PISEC!!.jpg"):
#		OS.alert("Игра обнаружила отсутствие самого важного файла. Игра больше не запустится. Наверное.\nВерните файл на место и не трогайте его ему страшно вообще капец.", "Aw, snap")
#		OS.crash("Fatal error")
		

# полезная функция™
func check(в_рот_мне_ноги: bool):
	if в_рот_мне_ноги:
		return true
	else:
		return false
		
func got_finishedsign(value):
	# ID которое используется для определения, в какую сцену отправить после анимации. Пока-что работают только встроенные анимации/сцены.
	match value:
		1:
			await get_tree().process_frame
			get_tree().change_scene_to_file(GAME)
		2:
			await get_tree().process_frame
			get_tree().change_scene_to_file(SETTINGS)
		3:
			await get_tree().process_frame
			get_tree().change_scene_to_file("res://mods.tscn")
		4:
			
			get_tree().quit()
		5:
			await get_tree().process_frame
			get_tree().change_scene_to_file("res://modsinternet.tscn")
		6:
			await get_tree().process_frame
			get_tree().change_scene_to_file("res://menu.tscn")
