"""
class_name SingletonManager extends Node

var _db = ResourceDatabase
var _s = {"name": "SingletonDatabase", "path": "res://data/singletons.tres"}


func _init():
	_db = ResourceDatabase.new("SingletonDatabase", 0, _s.path)
"""
