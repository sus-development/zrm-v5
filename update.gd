extends Panel
@onready var http: HTTPRequest = $HTTPRequest
var cleanCurVer = 0
var cleanNewVer = 0
var newVerUrl = "https://github.com/klodskateam/zurvival-remastered/releases"

var updUrl = "https://api.github.com/repos/klodskateam/zurvival-remastered/releases/latest"
var config = ConfigFile.new()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	config.load(Global.SAVE_PATH)
	var regex = RegEx.new()
	regex.compile("\\D")
	cleanCurVer = int(regex.sub(Global.VERSION, "", true))
	http.request(updUrl)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_rich_text_label_meta_clicked(meta: Variant) -> void:
	OS.shell_open(str(meta))


func _on_http_request_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	var data = JSON.parse_string(body.get_string_from_utf8())
	newVerUrl = data["html_url"]
	
	var regex = RegEx.new()
	regex.compile("\\D")
	cleanNewVer = int(regex.sub(data["name"], "", true))
	
	if cleanCurVer < cleanNewVer and cleanNewVer > config.get_value("settings", "ignoreupd", 0):
		#OS.alert("NEW VERSION")
		var regex2 = RegEx.new()
		regex2.compile("<[^>]*>")
		var tteexxtt = regex2.sub(data["body"], "", true)
		$Label/Label.text = data["name"]
		$RichTextLabel.text = tteexxtt
		show()
		
		
	


func _on_update_pressed() -> void:
	OS.shell_open(newVerUrl)


func _on_ignore_this_pressed() -> void:
	
	config.set_value("settings", "ignoreupd", cleanNewVer)
	config.save(Global.SAVE_PATH)
	queue_free()


func _on_close_pressed() -> void:
	queue_free()
