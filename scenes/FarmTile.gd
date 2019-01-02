extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var tile_index #the index of which child/tile is visible

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	randomize()
	
	tile_index = randi()%get_child(1).get_children().size()
	
	$BackTile.change_symbol(tile_index)
	$FrontTile.change_symbol(tile_index)
	
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

#function to change the tile

func change_tile(tile_index):
	
	$BackTile.change_symbol(tile_index)
	$FrontTile.change_symbol(tile_index)