@tool
class_name uuid extends Node

static var possibleCharacters : Array[String] = \
["a", "b", "c", "d", "e", "f",  
"A", "B", "C", "D", "E", "F", 
"0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]


static func generate() -> String:
	var firstUUIDSection : String
	var secondUUIDSection : String
	var thirdUUIDSection : String
	var fourthUUIDSection : String
	var fifthUUIDSection : String
	var finalUUID : String
	var uuidExists : bool = true


	for i in range(0, 8):
		firstUUIDSection += possibleCharacters.pick_random()
	
	for i in range(0, 4):
		secondUUIDSection += possibleCharacters.pick_random()
	
	for i in range(0, 4):
		thirdUUIDSection += possibleCharacters.pick_random()
	
	for i in range(0, 4):
		fourthUUIDSection += possibleCharacters.pick_random()
		
	for i in range(0, 12):
		fifthUUIDSection += possibleCharacters.pick_random()
	
	
	finalUUID = firstUUIDSection + "-" + secondUUIDSection + \
				"-" + thirdUUIDSection + "-" + fourthUUIDSection + "-" + fifthUUIDSection

	return finalUUID
