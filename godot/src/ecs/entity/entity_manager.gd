"""
tool
class_name EntityManager extends Singleton

export(int) var entities_maximum_amount setget set_entities_maximum_amount, get_entities_maximum_amount

const MAX_ENTITIES_AMOUNT = 4096
const MIN_ENTITIES_AMOUNT = 4

var data = {
    "max": MAX_ENTITIES_AMOUNT,
    "storage": [],
    'recycle_bin': [],
    "next_id": 0,
    "bin_size": 0
}

# setters, getters functions
func set_entities_maximum_amount(_max:int):
    if _max > MAX_ENTITIES_AMOUNT:# or _max < MIN_ENTITIES_AMOUNT:
        _max = MAX_ENTITIES_AMOUNT
    elif _max < MIN_ENTITIES_AMOUNT:
        _max = MIN_ENTITIES_AMOUNT
    data.max = _max
    
func get_entities_maximum_amount():
    return data.max

func _init():
    if resource_local_to_scene:
        resource_local_to_scene = false
    
    

package ecs.core;

import haxe.ds.Vector;

class EntityManager
{
    final storage : Vector<Entity>;
    final recycleBin : Vector<Int>;
    
    var nextID : Int;
    var binSize : Int;

    public function new(_max)
    {
        storage = new Vector(_max);
        recycleBin = new Vector(_max);
        nextID  = 0;
	binSize = 0;
    }

    public function create()
    {
        if (binSize > 0)
        {
            return storage[recycleBin[--binSize]];
        }
	   
        final idx = nextID++;
        final e   = new Entity(idx);

        storage[idx] = e;

        return e;
    }
    
    public function destroy(_id : Int)
    {
        recycleBin[binSize++] = _id;
    }

    public function get(_id : Int)
    {
        return storage[_id];
    }

    public function capacity()
    {
        return storage.length;
    }
}
"""

#============================================================================================

"""
class_name EntityManager extends Singleton  #Resource

enum EntityManagerState { NONE = 0, INIT = 1, UPDATE = 2, CREATE = 3, DESTROY = 4 }

const CLASS_NAME = "EntityManager"
const PATH = "res://src/ecs/entity_manager.gd"
const ID_MASK = 0xffffff
const ID_BITS_AMOUNT = 20
const VERSION_MASK = 0xfff << ID_BITS_AMOUNT
const COUNT_MIN = 4
const COUNT_MAX = 4096

var em_data: Dictionary

func _init().(CLASS_NAME, PATH, false, true):
	em_data = {
		"size": COUNT_MAX,#self.#COUNT_MAX,  #self.maximum_entity_amount,
		"count": 0,
		"cap": 0,
		"available": 0,
		"to_destroy": 0,
		"storage": [],
		"state":
		{
			"current": EntityManagerState.NONE,
			"has_size": false,
			"has_count": false,
			"has_cap": false,
			"has_available": false,
			"has_to_destroy": false,
			"has_storage": false
		}
	}

"""
"""
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


func get_at_cap():
	return available <= 0 && count >= cap && not has_available


func get_has_available():
	return available > 0


func get_length():
	return cap

func get_can_update():
	return state == EntityManagerState.INIT || EntityManagerState.UPDATE

func get_can_create():
	return has_available || not at_cap

func get_size():
	return size

func set_maximum_entity_amount(_maximum_entity_amount: int):
	if _maximum_entity_amount >= COUNT_MIN && _maximum_entity_amount <= COUNT_MAX:
		em_data.size = _maximum_entity_amount
	elif _maximum_entity_amount < COUNT_MIN:
		em_data.size = COUNT_MIN
	elif _maximum_entity_amount > COUNT_MAX:
		em_data.size = COUNT_MAX


func get_maximum_entity_amount():
	var max_amt = 0
	if em_data.size == 0 || em_data.size == null:
		max_amt = COUNT_MAX
	else:
		max_amt = em_data.size
	return max_amt


<=============================================================================================================================>

#export(int) var maximum_entity_amount setget set_maximum_entity_amount, get_maximum_entity_amount
#export(int) var next setget set_next, get_next
#export(bool) var at_cap setget , get_at_cap
#export(bool) var has_available setget , get_has_available
#export(int) var length setget , get_length
#export(bool) var can_update setget , get_can_update
#export(bool) var can_create setget , get_can_create
#export(int) var size setget , get_size

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

"""
