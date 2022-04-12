tool
class_name EntityManager extends Resource

export(int) var next setget set_next, get_next
export(bool) var at_cap setget set_at_cap, get_at_cap
export(bool) var has_available setget set_has_available, get_has_available
export(int) var length setget set_length, get_length
export(bool) var can_update setget set_can_update, get_can_update
export(bool) var can_create setget set_can_create, get_can_create
export(int) var size setget set_size, get_size

const ID_MASK = 0xffffff
const ID_BITS_AMOUNT = 20
const VERSION_MASK = 0xfff << ID_BITS_AMOUNT
const COUNT_MIN = 4
const COUNT_MAX = 4096

enum EntityManagerState { NONE = 0, INIT = 1, UPDATE = 2, CREATE = 3, DESTROY = 4 }

var count: int
var cap: int
var available: int
var to_destroy: int
var storage: Array
var state: int


func _init():
	count = 0
	cap = 0
	available = 0
	to_destroy = 0
	storage = []
	state = EntityManagerState.NONE

	if size < COUNT_MIN:
		size = COUNT_MIN
	elif size > COUNT_MAX:
		size = COUNT_MAX

	for i in cap + 1:
		if _skip(i):
			continue
		storage[i] = _id(i, 0)

	available = cap

	for i in available + 1:
		if _skip(i):
			continue
		_do_create()

	for i in count + 1:
		if _skip(i):
			continue
		to_destroy = _id(i, 0)
		_do_destroy()

	state = EntityManagerState.INIT


func _skip(_i: int):
	return _i == 0


func update():
	if can_update:
		match state:
			EntityManagerState.INIT:
				_on_update()
			EntityManagerState.CREATE:
				if has_available:  # recycle
					var pop = get_next()
					var push = pop
					var idx = _parse_idx(push)
					for i in available:
						pop = storage[idx]
						storage[idx] = push
						push = pop
						idx = _parse_idx(push)
						if i == available:
							set_next(push)
					available = available - 1
					_on_update()
				elif at_cap:
					_on_create()
				else:
					_do_create()
			EntityManagerState.DESTROY:
				_do_destroy()
			_:
				_on_update()


func create():
	if get_can_create():
		_on_create()


func destroy(_id: int):
	if _can_destroy(_id):
		to_destroy = _id
		state = EntityManagerState.DESTROY


func _can_destroy(_id: int):
	return storage[_parse_idx(_id)] == _id


func _on_update():
	state = EntityManagerState.UPDATE


func _on_create():
	state = EntityManagerState.CREATE


func _parse_version(_id: int):
	return (_id & VERSION_MASK) >> ID_BITS_AMOUNT


func _parse_idx(_id: int):
	return _id & ID_MASK


func _id(_idx: int, _version: int):
	return ((_version << ID_BITS_AMOUNT) & VERSION_MASK) | (_idx & ID_MASK)


func _do_create():
	var idx = count + 1
	var id = _id(idx, 0)
	storage[idx] = id
	count = count + 1
	_on_update()


func _do_destroy():
	var idx = _parse_idx(to_destroy)
	var id = _id(idx, _parse_version(to_destroy) + 1)
	storage[idx] = id
	set_next(id)
	available = available + 1
	_on_update()


# setters, getters functions
func set_next(_next: int):
	storage[0] = _next


func get_next():
	return storage[0]


func set_at_cap(_at_cap: bool):
	pass


func get_at_cap():
	return available <= 0 && count >= cap && not has_available


func set_has_available(_has_available: bool):
	pass


func get_has_available():
	return available > 0


func set_length(_length: int):
	pass


func get_length():
	return cap


func set_can_update(_can_update: bool):
	pass


func get_can_update():
	return state == EntityManagerState.INIT || EntityManagerState.UPDATE


func set_can_create(_can_create: bool):
	pass


func get_can_create():
	return has_available || not at_cap


func set_size(_size: int):
	pass


func get_size():
	return size
