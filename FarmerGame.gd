extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

export (PackedScene) var FarmTile
export (PackedScene) var DirtTile

#STANDARD SCENE GLOBALS
var world_width #the size of the map (in pixels)
var world_height #the size of the map (in pixels)
var map_width #the size of the map (in cells/tiles)
var map_height #the size of the map (in cells/tiles)
var cell_size #the amount of pixels in a cell/tile

#Farming Vars
var map_tiles = [] #keeps track of all the tiles in the map. access: [ypos*map_width + xpos]

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	randomize()
	
	#Screen Dimension stuff
	world_width = get_viewport().size.x
	world_height = get_viewport().size.y
	map_width = int($TileMap.world_to_map(Vector2(world_width,0)).x)
	map_height = int($TileMap.world_to_map(Vector2(0,world_height)).y)
	cell_size = $TileMap.cell_size #get the cell size for these next calculations
	
#	#Initialize fields
#	#var tile_type = randi()%13  # the type of tile it will be
#	var tile_type = 0
#	for i in range(10):
#		for j in range(10):
#
#			var temp_position #the temporary posittion of the tile we're placing
#			temp_position = $TileMap.map_to_world(Vector2(7+i, 3+j))
#
#			#actually create it
#			var temp_tile = FarmTile.instance()
#			temp_tile.position = temp_position
#			add_child(temp_tile)
#			temp_tile.change_tile(tile_type)
			
	
#	#A dirt field
#	for i in range(10):
#		for j in range(10):
#			var temp_pos 
#			temp_pos = $TileMap.map_to_world(Vector2( 20+i, 3+j ))
#
#			#creation
#			var temp_tile = DirtTile.instance()
#			temp_tile.position = temp_pos
#			add_child(temp_tile)
			
			
	#Initialize map_tiles array
	for i in range(map_width):
		for j in range(map_height):
			map_tiles.append(null)
	
	#Make the whole map dirt tiles...
	for i in range(map_width):
		for j in range(map_height):
			#Calculate global position
			var temp_position = $TileMap.map_to_world(Vector2(i,j))
			
			#Create the new tile
			var temp_tile = DirtTile.instance()
			temp_tile.position = temp_position
			add_child(temp_tile)
			map_tiles[j*map_width + i] = temp_tile
	
	#Going to build a grid of different types of fields
	
	#print(MedAlgo.zig_zag_path(Vector2(1,1), 4,4))
	#$Creature.flip_sprites()
	#print($Creature.personal_tool.position)
	
	$Creature.path = MedAlgo.zig_zag_path(Vector2(1,1), 20,20)
	#$Creature.flip_sprites()
	print($Creature.path)
	
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#
#	pass
