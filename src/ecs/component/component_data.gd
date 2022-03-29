extends Resource

export(Resource) var meta
export(Resource) var main

func _init(_meta = null, _main = null):
    meta = _meta
    main = _main