extends TextDatabase
class_name SignalDatabase

var db = null

func _initialize():
    db = TextDatabase.new()
    db.load_from_path("res://signal_db.cfg")

func _preprocess_entry():
    
#db.load_from_path("res://signal_db.cfg")
