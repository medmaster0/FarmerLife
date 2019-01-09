extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

export (PackedScene) var FarmTile
export (PackedScene) var DirtTile

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	randomize()
	
	
	#Initialize fields
	#var tile_type = randi()%13  # the type of tile it will be
	var tile_type = 0
	for i in range(10):
		for j in range(10):
			
			var temp_position #the temporary posittion of the tile we're placing
			temp_position = $TileMap.map_to_world(Vector2(7+i, 3+j))
			
			#actually create it
			var temp_tile = FarmTile.instance()
			temp_tile.position = temp_position
			add_child(temp_tile)
			temp_tile.change_tile(tile_type)
			
	
	#A dirt field
	for i in range(10):
		for j in range(10):
			var temp_pos 
			temp_pos = $TileMap.map_to_world(Vector2( 20+i, 3+j ))
			
			#creation
			var temp_tile = DirtTile.instance()
			temp_tile.position = temp_pos
			add_child(temp_tile)
			
			
	
	#Going to build a grid of different types of fields
	
	#scale = Vector2(2,2)
#
#	for child in get_children():
#		child.scale = Vector2(2,2)
	
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
