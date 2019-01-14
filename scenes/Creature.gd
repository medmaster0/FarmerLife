extends Node2D

export (PackedScene) var Tool
export (PackedScene) var DirtTile
export (PackedScene) var FarmTile

onready var map = get_parent().find_node("TileMap")
#Farming onreadies
onready var map_tiles = get_parent().map_tiles
var map_width #need a key to the map_tiles...

#Movement stuff
var step_tick = 0.5 #time period for each step
var step_timer = 0 #will help keep track of when we stepped
var path = [] #A set of steps to follow in pathfinding (usually set outside)

#FARMING STUFF
var personal_tool #Holds the creature's tool scene (if applicable?)
var job_id #keeps track of which stage and tool creature is performing
#JOB IDS
# 0 - First Plow (Plough)
# 1 - Second (Cross) Plow (Plough)
# 2 - Gentle Furrow Plow (Plough)
# 3 - Plant Seeds (Bag)
# 4 - Spread Seeds (Rake)
# 5 - Cover Seeds (Also Rake)
# 6 - Dig Ditches to Water (Shovel)
# 7 - Hoe Weeds (Hoe)
# 8 - Reap (Scythe)
# 9 - Carry (Hold Bushel)
# 10 - Store (Wheelbarrow)
# 11 - Sell... (Coin?)

#some wtf stuff...
var soil_color #each *Creature* needs to keep track of soil color (since they create the new FarmTiles

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	randomize()
	
	#Add color
	$Sprite.modulate = Color(randf(), randf(), randf())
	
	#Change job type
	change_job_type(0)
	
	#MAP BULLSHIT>...
	map_width = int(map.world_to_map(Vector2(get_viewport().size.x,0)).x)
	
	#SOIL BULLSHIT
	soil_color = MedAlgo.generate_dirt_color()
	
	pass

func _process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	
	step_timer = step_timer + delta
	if step_timer > step_tick:
		#path_step()
		farm_path_step()
		#update timer
		step_timer = step_timer - step_tick
	
	pass

#A function that takes a step in the stored path
#Returns true if done with path
#Returns false if not
###GOTTA MAKE SURE THIS MAP VARIABLE GETS SET OUTSIDE TOO....
func path_step():
	
	if path.size() == 0:
		return(true) #Do nothing since there are no more steps left
	
	#Take the first Vector2 in the list
	var next_coords = path.pop_front()
	
	#Move the Creature there (remember to convert to world coords from map)
	position = map.map_to_world(next_coords)
	
	return(false)

#FARMING STUFF SHIT FUCK
#
#
#Gonna eventually make a "Farming path step"
#That changes the underlying map???
#How do we change the underlying map?...... so many fucking questions... im going nuts here
# the creature's algorithm will "look up"
#to the encompassing game and then into the map_tiles and stuff... oh boy....
func farm_path_step():
	
	#Change the underlying tile, (then work on stepping)
	var map_coords = map.world_to_map(position)
	#What happens to the tile dpends on creature job type...
	match(job_id):
		0:
			#Delete whatever tile is there and make a ploughed tile....
			if map_tiles[map_coords.y*map_width + map_coords.x] != null:
				map_tiles[map_coords.y*map_width + map_coords.x].queue_free()
				map_tiles[map_coords.y*map_width + map_coords.x] = null
			var temp_tile = FarmTile.instance()
			temp_tile.position = position
			get_parent().add_child(temp_tile)
			temp_tile.change_tile(0)
			temp_tile.change_color(soil_color)
			map_tiles[map_coords.y*map_width + map_coords.x] = temp_tile
		1:
			#Delete whatever tile is there and make a ploughed tile....
			if map_tiles[map_coords.y*map_width + map_coords.x] != null:
				map_tiles[map_coords.y*map_width + map_coords.x].queue_free()
				map_tiles[map_coords.y*map_width + map_coords.x] = null
			var temp_tile = FarmTile.instance()
			temp_tile.position = position
			get_parent().add_child(temp_tile)
			temp_tile.change_tile(1)
			temp_tile.change_color(soil_color)
			map_tiles[map_coords.y*map_width + map_coords.x] = temp_tile
		2:
			#Delete whatever tile is there and make a ploughed tile....
			if map_tiles[map_coords.y*map_width + map_coords.x] != null:
				map_tiles[map_coords.y*map_width + map_coords.x].queue_free()
				map_tiles[map_coords.y*map_width + map_coords.x] = null
			var temp_tile = FarmTile.instance()
			temp_tile.position = position
			get_parent().add_child(temp_tile)
			temp_tile.change_tile(2)
			temp_tile.change_color(soil_color)
			map_tiles[map_coords.y*map_width + map_coords.x] = temp_tile
		3:
			#Delete whatever tile is there and make a ploughed tile....
			if map_tiles[map_coords.y*map_width + map_coords.x] != null:
				map_tiles[map_coords.y*map_width + map_coords.x].queue_free()
				map_tiles[map_coords.y*map_width + map_coords.x] = null
			var temp_tile = FarmTile.instance()
			temp_tile.position = position
			get_parent().add_child(temp_tile)
			temp_tile.change_tile(3)
			temp_tile.change_color(soil_color)
			map_tiles[map_coords.y*map_width + map_coords.x] = temp_tile
		4:
			#Delete whatever tile is there and make a ploughed tile....
			if map_tiles[map_coords.y*map_width + map_coords.x] != null:
				map_tiles[map_coords.y*map_width + map_coords.x].queue_free()
				map_tiles[map_coords.y*map_width + map_coords.x] = null
			var temp_tile = FarmTile.instance()
			temp_tile.position = position
			get_parent().add_child(temp_tile)
			temp_tile.change_tile(4)
			temp_tile.change_color(soil_color)
			map_tiles[map_coords.y*map_width + map_coords.x] = temp_tile
		5:
			#Delete whatever tile is there and make a ploughed tile....
			if map_tiles[map_coords.y*map_width + map_coords.x] != null:
				map_tiles[map_coords.y*map_width + map_coords.x].queue_free()
				map_tiles[map_coords.y*map_width + map_coords.x] = null
			var temp_tile = FarmTile.instance()
			temp_tile.position = position
			get_parent().add_child(temp_tile)
			temp_tile.change_tile(5)
			temp_tile.change_color(soil_color)
			map_tiles[map_coords.y*map_width + map_coords.x] = temp_tile
		6:
			#Delete whatever tile is there and make a ploughed tile....
			if map_tiles[map_coords.y*map_width + map_coords.x] != null:
				map_tiles[map_coords.y*map_width + map_coords.x].queue_free()
				map_tiles[map_coords.y*map_width + map_coords.x] = null
			var temp_tile = FarmTile.instance()
			temp_tile.position = position
			get_parent().add_child(temp_tile)
			temp_tile.change_tile(6)
			temp_tile.change_color(soil_color)
			map_tiles[map_coords.y*map_width + map_coords.x] = temp_tile
		7:
			#Delete whatever tile is there and make a ploughed tile....
			if map_tiles[map_coords.y*map_width + map_coords.x] != null:
				map_tiles[map_coords.y*map_width + map_coords.x].queue_free()
				map_tiles[map_coords.y*map_width + map_coords.x] = null
			var temp_tile = FarmTile.instance()
			temp_tile.position = position
			get_parent().add_child(temp_tile)
			temp_tile.change_tile(7)
			temp_tile.change_color(soil_color)
			map_tiles[map_coords.y*map_width + map_coords.x] = temp_tile
		8:
			#Delete whatever tile is there and make a ploughed tile....
			if map_tiles[map_coords.y*map_width + map_coords.x] != null:
				map_tiles[map_coords.y*map_width + map_coords.x].queue_free()
				map_tiles[map_coords.y*map_width + map_coords.x] = null
			var temp_tile = FarmTile.instance()
			temp_tile.position = position
			get_parent().add_child(temp_tile)
			temp_tile.change_tile(8)
			temp_tile.change_color(soil_color)
			map_tiles[map_coords.y*map_width + map_coords.x] = temp_tile
		9:
			#Delete whatever tile is there and make a ploughed tile....
			if map_tiles[map_coords.y*map_width + map_coords.x] != null:
				map_tiles[map_coords.y*map_width + map_coords.x].queue_free()
				map_tiles[map_coords.y*map_width + map_coords.x] = null
			var temp_tile = FarmTile.instance()
			temp_tile.position = position
			get_parent().add_child(temp_tile)
			temp_tile.change_tile(9)
			temp_tile.change_color(soil_color)
			map_tiles[map_coords.y*map_width + map_coords.x] = temp_tile
		10:
			#Delete whatever tile is there and make a ploughed tile....
			if map_tiles[map_coords.y*map_width + map_coords.x] != null:
				map_tiles[map_coords.y*map_width + map_coords.x].queue_free()
				map_tiles[map_coords.y*map_width + map_coords.x] = null
			var temp_tile = FarmTile.instance()
			temp_tile.position = position
			get_parent().add_child(temp_tile)
			temp_tile.change_tile(10)
			temp_tile.change_color(soil_color)
			map_tiles[map_coords.y*map_width + map_coords.x] = temp_tile
	
	if path.size() == 0:
		return(true) #Do nothing since there are no more steps left
	
	#Take the first Vector2 in the list
	var next_coords = path.pop_front()
	
	#Check if the new coords are in a different row (changed y coords)
	#Then we need to flip around the other way...
	if next_coords.y != map.world_to_map(position).y:
		flip_sprites()
	
	#Move the Creature there (remember to convert to world coords from map)
	position = map.map_to_world(next_coords)
	
	
	return(false)

#A function that handles flipping the sprites and tools in the opposite direction
#Adjust scale (negative) to flip in opposite direction
#When changing scale, also need to recenter...
#Change the sprites' and Tool's personal position also...
func flip_sprites():
	scale.x = scale.x * -1
	$Sprite.position.x = $Sprite.position.x + ( scale.x * 16 )
	$Sprite2.position.x = $Sprite2.position.x + ( scale.x * 16 )
	if personal_tool != null:
		personal_tool.position.x = personal_tool.position.x + ( scale.x * 16 )

#JOB IDS
# 0 - First Plow (Plough)
# 1 - Second (Cross) Plow (Plough)
# 2 - Gentle Furrow Plow (Plough)
# 3 - Plant Seeds (Bag)
# 4 - Spread Seeds (Rake)
# 5 - Cover Seeds (Also Rake)
# 6 - Dig Ditches to Water (Shovel)
# 7 - Hoe Weeds (Hoe)
# 8 - Reap (Scythe)
# 9 - Carry (Hold Bushel)
# 10 - Store (Wheelbarrow)
# 11 - Sell... (Coin?)

#Change farming job (and tool)
func change_job_type(type):
	job_id = type
	
	#Destroy current tool...
	if personal_tool!=null:
		personal_tool.queue_free()
	personal_tool = null
	match(job_id):
		0:
			#Plough
			var new_tool = Tool.instance()
			add_child(new_tool)
			new_tool.change_tile(1)
			personal_tool = new_tool
		1:
			#Plough
			var new_tool = Tool.instance()
			add_child(new_tool)
			new_tool.change_tile(1)
			personal_tool = new_tool
		2:
			#Plough
			var new_tool = Tool.instance()
			add_child(new_tool)
			new_tool.change_tile(1)
			personal_tool = new_tool
		3:
			#Seed Bag
			var new_tool = Tool.instance()
			add_child(new_tool)
			new_tool.change_tile(6)
			personal_tool = new_tool
		4:
			#Rake
			var new_tool = Tool.instance()
			add_child(new_tool)
			new_tool.change_tile(2)
			personal_tool = new_tool
			#The rake position requires creature to be flipped...
			flip_sprites()
		5:
			#Rake
			var new_tool = Tool.instance()
			add_child(new_tool)
			new_tool.change_tile(2)
			personal_tool = new_tool
			#The rake position requires creature to be flipped...
			flip_sprites()
		6:
			#Shovel
			var new_tool = Tool.instance()
			add_child(new_tool)
			new_tool.change_tile(4)
			personal_tool = new_tool
			#The rake position requires creature to be flipped...
			flip_sprites()
		7:
			#Hoe
			var new_tool = Tool.instance()
			add_child(new_tool)
			new_tool.change_tile(0)
			personal_tool = new_tool
			#The rake position requires creature to be flipped...
			flip_sprites()
		8:
			#Scythe
			var new_tool = Tool.instance()
			add_child(new_tool)
			new_tool.change_tile(3)
			personal_tool = new_tool
			#The rake position requires creature to be flipped...
			#flip_sprites()
		9:
			#Nothing...
			personal_tool = null
	


#I just wanna say, fuck shit fuck you shit fuck fuck fuck fuck 