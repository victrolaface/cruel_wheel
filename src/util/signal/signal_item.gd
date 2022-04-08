extends TextDatabase
class_name SignalItem

var item = null

func _initialize():
    item = TextDatabase.new()
    item.load_from_path("res://signal_item.cfg")
    item.mandatory_properties = []
    #item.add_default_value("description", "An item entry for a connected signal in the signal database.")
    #item.add_mandatory_property("obj_from", Object)
    """
    [Signal Item]
description = "An item entry for a connected signal in the signal database."
obj_from = null
connected = false
signal = ""
obj_to = null
method = ""
args = []
flags = []
    """
    #item.load_from_path("res://signal_item.cf")