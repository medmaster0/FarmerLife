extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

export (PackedScene) var FarmTile

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	randomize()
	
	#Initialize fields
	for i in range(10):
		for j in range(10):
			
			var temp_position #the temporary posittion of the tile we're placing
			temp_position = $TileMap.map_to_world(Vector2(8+i, 4+j))
			
			var tile_type = 12  # the type of tile it will be
			
			#actually create it
			var temp_tile = FarmTile.instance()
			temp_tile.position = temp_position
			add_child(temp_tile)
			temp_tile.change_tile(tile_type)
			
	
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
