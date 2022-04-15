class_name EntityData extends Resource

export(int) var id setget set_id, get_id
export(Resource) var components setget set_components, get_components
export(Resource) var manager setget set_manager, get_manager
export(Resource) var state setget set_state, get_state


func _init():
    resource_local_to_scene = true
    id = 0
    components = ResourceSet.new()
"""
data = {
        "id": 0,
        "components": null,
        "manager": null,
        "state": {
            "request_id_connected": false,
            "received_id_connected": false,
            "initialized_connected": false,
            "updated_connected": false,
            "enabled_connected": false,
            "disabled_connected": false,
            "destroyed_connected": false,
            "has_id": false,
            "has_components": false,
            "intialized": false,
            "enabled": false,
            "destroyed": false
        }
    }
"""