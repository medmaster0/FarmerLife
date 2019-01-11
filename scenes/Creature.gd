extends Node2D

export (PackedScene) var Tool

onready var map = get_parent().find_node("TileMap")

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


func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	randomize()
	
	#Add color
	$Sprite.modulate = Color(randf(), randf(), randf())
	
	#Change job type
	change_job_type(0)
	
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
	
	print(type)
