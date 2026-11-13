extends Control

var value: String = "0.0":
	get: return value
	set(new_value):
		value = new_value
		$TextureRect/VabrationValue.text = value
