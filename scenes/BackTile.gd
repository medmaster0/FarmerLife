extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var tile_index #the index of which child/tile is visible

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	randomize()
	
	tile_index = randi()%get_children().size()
	#get_child(tile_index).visible = true
	change_symbol(tile_index)
	
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func change_symbol(new_tile_index):
	
	#Turn off old one...
	#var temp_color = get_child(tile_index).modulate #save the color
	get_child(tile_index).visible = false
	
	#Change to new one
	tile_index = new_tile_index
	get_child(tile_index).visible = true
	#get_child(tile_index).modulate = temp_color