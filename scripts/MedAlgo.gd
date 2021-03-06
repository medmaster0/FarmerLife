
extends Node

#Caclulate the "opposite color"
#This is the color with each of it's rgb channels 128 (or 0.5) away from the color
#ex. (255,108,176) and (128,236,48)
func oppositeColor(in_col):
	
	var r = in_col.r + 0.5
	if r > 1:
		r = r - 1
	var g = in_col.g + 0.5
	if g > 1:
		g = g - 1
	var b = in_col.b + 0.5
	if b > 1:
		b = b - 1
	
	var out_col = Color(r,g,b)
	return out_col
	
	
#Determine which color will better contrast input color:
#Black or White?	
func contrastColor(in_col):
	
	var in_brightness_count = 0 #this will keep track of which channels are bright (over 0.5)
	if in_col.r > 0.5:
		in_brightness_count = in_brightness_count + 1
	if in_col.g > 0.5:
		in_brightness_count = in_brightness_count + 1
	if in_col.b > 0.5:
		in_brightness_count = in_brightness_count + 1
		
	#If the majority of channels are bright, return black (for contrast)
	if in_brightness_count >=2:
		return(Color(0,0,0))
	#Otherwise return white
	else: 
		return(Color(1,1,1))
	
	
#Blend two colors
func blendColor(col1, col2):
	
	var r = (col1.r+col2.r)/2.0
	var g = (col1.g+col2.g)/2.0
	var b = (col1.b+col2.b)/2.0
	return( Color(r,g,b) )
	
#Generate color cycle schema
#These are meant to be moody color that cycle unto each other
#Right now, RANDOM
#eventually more artistic and shit
#Things we can filter:
	#Green? doesn't look good as a sky
	#blue? pure doesn't look good as a sky neither...
	#too much red will get boring, some otherworldy is cool
	# like one or two out of all of them can be freaky, but no more
func colorCycle():
	
	randomize() #randomize just to be safe, fuckhead
	
	var colors = [] #the list of colors that form the cycle
	
	#now add some random colors boyeee
	var cycle_length = randi()%3 + 3
	for i in range(cycle_length):
		colors.append(Color(randf(),randf(), randf()))
	
	return colors
	
#MAYBE TODO????????
#Generates a discrete list of colors to go through
#that slowly changes ino one from the other
#Will list colors to get from color1 to color2, in random RGB increments

#Function that will return a color a step in the "direction" of the other step
func colorTransitionStep(color1,color2):
	
	#Determine how big of steps to adjust each color channel in
	var STEP_SIZE = 0.0125
	
	var temp_color = color1 #the color we'll be returning (will be manipulated but starts at color1)
	
	#We first need to analyze which channels need to go higher or lower
	var shouldGoUp = [] #will hold boolean values indicating if channel should go up or down
	for i in range(3):
		if color1[i] < color2[i]: #If target is greater
			shouldGoUp.append(true)
		else: #then target is lower
			shouldGoUp.append(false)
			
	#Need to pick which channel (R,G, or B) we'll change
	var channel_choice = randi()%3 
	match(channel_choice):
		0:
			#Chose Red
			#Check array for if we should increment or decrement
			if shouldGoUp[0] == true:
				temp_color.r = temp_color.r + STEP_SIZE
			else:
				temp_color.r = temp_color.r - STEP_SIZE
		1:
			#Chose Green
			#Check array for if we should increment or decrement
			if shouldGoUp[1] == true:
				temp_color.g = temp_color.g + STEP_SIZE
			else:
				temp_color.g = temp_color.g - STEP_SIZE
		2:
			#Chose Blue
			#Check array for if we should increment or decrement
			if shouldGoUp[2] == true:
				temp_color.b = temp_color.b + STEP_SIZE
			else:
				temp_color.b = temp_color.b - STEP_SIZE
	
	return(temp_color)




#A STAR FUNCTIONS!!!!
#A* Path Finding 
#returns an array of steps to follow between the two points
#returns (9999,9999) if no path 
#input two vectors you want to search for (global non-tilemap coords)
#
#Also need a tile map that you search on
#
#RETURNS MAP COORDS!
#How it works:
#We have two sets, open and closed set
func find_path(global_start, global_end, tile_map):
	
	#Function vars
	var open_set = []
	var closed_set = []
	var walkable_tiles = [0,1,2,3,4]
	
	#Convert the coordinates to map_coords
	var start = tile_map.world_to_map(global_start)
	var end = tile_map.world_to_map(global_end)

	#Create the FIRST node
	var temp_node = {
		"g" : 0,
		"h" : abs(start.x - end.x) + abs(start.y - end.y),
		"f" : abs(start.x - end.x) + abs(start.y - end.y),
		"coords" : start,
		"last_node" : null
	}
	#And add it to the open_set
	open_set.append(temp_node)
	
	#Now an infinite loop that only breaks once we find our target...
	while(true):
		
		#print(open_set.size())
		
		#EACH ITERATION...
		#find the node in open_set with the least f (next node)
		var least_f = 9999 #temp var to keep track of what the lowest f is
		var next_node #the temp var for the node that has the lowest f
		for node in open_set:
			if node.f <= least_f: #use equals so we get the last one checked (added to open set)
				next_node = node
				least_f = node.f
		#next_node now points to the node with the lowest f
		
		#if there is no next_node (we got through open set), then just exit
		if next_node == null:
			print("got to end of open set and no target")
			return(false)
		
		#remove that node from open_set (so we don't check it again)
		open_set.erase(next_node)
		
		#Now, add each of next_node's neighbors (if walkable)
		#RIGHT
		if tile_map.get_cell(next_node.coords.x+1, next_node.coords.y) in walkable_tiles:
			#Make a new node (with calculations) and add to set
			var temp_x = next_node.coords.x+1
			var temp_y = next_node.coords.y
			if Vector2(temp_x,temp_y) == end: #check if reached target
				return( path_from_set(next_node,end) )
				break
				
			#Check if node coords have already been entered in closed_set
			if isVectorInSet(Vector2(temp_x,temp_y), closed_set) == false: #If not closed yet
				#Then add a new node for those coords
				var neighbor_node = {
					"g" : next_node.g + 1,
					"h" : abs(end.x - temp_x) + abs(end.y - temp_y), #Manhattan Distance"
					"f" : "not set yet",
					"coords" : Vector2(temp_x, temp_y),
					"last_node" : next_node
				}
				neighbor_node.f = neighbor_node.g + neighbor_node.h #Now calculate f
				open_set.append(neighbor_node)
			
		#LEFT
		if tile_map.get_cell(next_node.coords.x-1, next_node.coords.y) in walkable_tiles:
			#Make a new node (with calculations) and add to set
			var temp_x = next_node.coords.x-1
			var temp_y = next_node.coords.y
			if Vector2(temp_x,temp_y) == end: #check if reached target
				return( path_from_set(next_node,end) )
				break
				
			#Check if node coords have already been entered in closed_set
			if isVectorInSet(Vector2(temp_x,temp_y), closed_set) == false: #If not closed yet
				#Then add a new node for those coords
				var neighbor_node = {
					"g" : next_node.g + 1,
					"h" : abs(end.x - temp_x) + abs(end.y - temp_y), #Manhattan Distance"
					"f" : "not set yet",
					"coords" : Vector2(temp_x, temp_y),
					"last_node" : next_node
				}
				neighbor_node.f = neighbor_node.g + neighbor_node.h #Now calculate f
				open_set.append(neighbor_node)
			
		#UP
		if tile_map.get_cell(next_node.coords.x, next_node.coords.y-1) in walkable_tiles:
			#Make a new node (with calculations) and add to set
			var temp_x = next_node.coords.x
			var temp_y = next_node.coords.y-1
			if Vector2(temp_x,temp_y) == end: #check if reached target
				return( path_from_set(next_node,end) )
				break
				
			#Check if node coords have already been entered in closed_set
			if isVectorInSet(Vector2(temp_x,temp_y), closed_set) == false: #If not closed yet
				#Then add a new node for those coords
				var neighbor_node = {
					"g" : next_node.g + 1,
					"h" : abs(end.x - temp_x) + abs(end.y - temp_y), #Manhattan Distance"
					"f" : "not set yet",
					"coords" : Vector2(temp_x, temp_y),
					"last_node" : next_node
				}
				neighbor_node.f = neighbor_node.g + neighbor_node.h #Now calculate f
				open_set.append(neighbor_node)
			
		#DOWN
		if tile_map.get_cell(next_node.coords.x, next_node.coords.y+1) in walkable_tiles:
			#Make a new node (with calculations) and add to set
			var temp_x = next_node.coords.x
			var temp_y = next_node.coords.y+1
			if Vector2(temp_x,temp_y) == end: #check if reached target
				return( path_from_set(next_node, end) )
				break
				
			#Check if node coords have already been entered in closed_set
			if isVectorInSet(Vector2(temp_x,temp_y), closed_set) == false: #If not closed yet
				#Then add a new node for those coords
				var neighbor_node = {
					"g" : next_node.g + 1,
					"h" : abs(end.x - temp_x) + abs(end.y - temp_y), #Manhattan Distance"
					"f" : "not set yet",
					"coords" : Vector2(temp_x, temp_y),
					"last_node" : next_node
				}
				neighbor_node.f = neighbor_node.g + neighbor_node.h #Now calculate f
				open_set.append(neighbor_node)
			
		#Finally, add the node to the closed set
		closed_set.append(next_node)
			
	#end while - If this while broke, means we found target
	

#A utility function for A* that will reconstruct the path from given node
#Returns a list of steps only 
#array of Vector2
func path_from_set(latest_node, end_coords):
	
	var path_array = [] #The list of coords we'll be returning back
	
	var current_node = latest_node #temp node for interating list
	while(current_node.last_node != null):
		path_array.push_front(current_node.coords)
		current_node = current_node.last_node
		
	path_array.append(end_coords)
		
	return(path_array)
		

#Checks if the input coords (Vector2) have already been entered in the search set
func isVectorInSet(search_coords, search_set):
	
	#Iterate through all the nodes in set
	for node in search_set:
		if search_coords == node.coords: #If the coords match the target
			return(true)
	
	#If it makes it here, not in set
	return(false)
#END A STAR SEARCH AFFILIATED FUNCTIONS
	


#GENERAL FLOOD SEARCH
#POSSIBLY GENERAL USE??? LETS SEE ONCE IMPLEMENTED SINCE IM WRITING THIS BEFORE
#This is a flood search
#Creates a list of nodes
#RETURNS MAP COORDS!
#Nodes have form: (position, distance from target)
func find_tile(global_start, target_tile, tile_map):
	
	var walkable_tiles = [0,1,2,3,4]
	
	var search_q = [] #The list of nodes to search through
	var search_index = 0 #Which node in the search queue we are currently searching
	
	#Add First node
	var temp_position = tile_map.world_to_map(global_start)
	var temp_distance = 0
	var temp_node = {
					"coords": temp_position, 
					"distance": temp_distance}
	search_q.append(temp_node)

	#Now iterate the search queue , will have to break out when found target
	while(true):
		
		#get the next node
		var next_node = search_q[search_index]
		
		#Check if that node was the target?!??!
		if tile_map.get_cellv(next_node.coords) == target_tile:
			break
			
		#else, need to add all the other nodes onto search queue
		### ALL ADJACENT NODES
		#LEFT
		if tile_map.get_cell(next_node.coords.x-1, next_node.coords.y) in walkable_tiles:
			var new_node = {
				"coords": next_node.coords + Vector2(-1,0),
				"distance": next_node.distance + 1
				}
			#Make sure the new node isn't already in the search_q
			if isVectorInSet(new_node.coords,search_q) == false:
				search_q.append(new_node)
			
		#RIGHT
		if tile_map.get_cell(next_node.coords.x+1, next_node.coords.y) in walkable_tiles:
			var new_node = {
				"coords": next_node.coords + Vector2(1,0),
				"distance": next_node.distance + 1
				}
			#Make sure the new node isn't already in the search_q
			if isVectorInSet(new_node.coords,search_q) == false:
				search_q.append(new_node)
			
		#UP
		if tile_map.get_cell(next_node.coords.x, next_node.coords.y-1) in walkable_tiles:
			var new_node = {
				"coords": next_node.coords + Vector2(0,-1),
				"distance": next_node.distance + 1
				}
			#Make sure the new node isn't already in the search_q
			if isVectorInSet(new_node.coords,search_q) == false:
				search_q.append(new_node)
			
		#DOWN
		if tile_map.get_cell(next_node.coords.x, next_node.coords.y+1) in walkable_tiles:
			var new_node = {
				"coords": next_node.coords + Vector2(0,1),
				"distance": next_node.distance + 1
				}
			#Make sure the new node isn't already in the search_q
			if isVectorInSet(new_node.coords,search_q) == false:
				search_q.append(new_node)
			
		#Move on to the next node
		search_index = search_index + 1

	#end while
	print("found target")
	
	#Now need to go through and construct the path back
	var return_path = []
	return_path.push_front(search_q[search_index].coords)
	#cycle through the search_q
	while(search_index != -1):
		#go back down the search_q in reverse
		search_index = search_index - 1
		
		#check if the next tile is within one step of the next return step
		if search_q[search_index].coords.distance_to(return_path[0]) == 1:
			return_path.push_front(search_q[search_index].coords)
		
	
	#return the path
	return(return_path)


#A function for generating a zigzag pattern path...
#Start at left corner
#go right for the row_duration
#move on to step below and go back along row
#Input/Output in map coords!
func zig_zag_path(start, row_duration, num_rows):
	var path = [] #the path we return
	var direction = 1 #start of going in positive direction (1), then go backwards (-1)
	
	var ref_pos = start 
	for j in range(num_rows):
		#Go along row
		for i in range(row_duration):
			var temp_position = Vector2(ref_pos.x + (direction*i), ref_pos.y)
			path.append(temp_position)
		#When finished with row, move on to next one
		#Do this by placing ref_pos at the start of the next row where we left off (alternating sides)
		ref_pos.y = ref_pos.y + 1
		ref_pos.x = ref_pos.x + (direction*(row_duration-1))
		#Then also change direction for next row...
		direction = direction * -1
	
	return(path)
	

#generate a shade of golden yellow (for the perfume gold topper thingy)
#kinda green and (antiquey) -> shitty for hair and stuff
func generate_gold():
	
	var r = 0.7 + rand_range(0,0.3)
	#var g = rand_range(0,r)
	var g = rand_range(0.7,r)
	var b = 0
	
	var gold = Color(r,g,b)
	return(gold)
	

#generate a shade of random brown
#Also kinda green -> good for stems, not skin colors...
func generate_brown():
	
	var r = 0.6 + rand_range(0,0.2)
	var g = r - rand_range(0,0.2) - 0.2 #between a fifth and 2 fifths less than r
	var b = rand_range(0,g) #no more than g
	
	var brown = Color(r,g,b)
	return(brown)

#Human(ish) stuff

#Generate a random hair color
#Selecte from three bases -> black, blonde, red
func generate_hair_color():
	
	#The components to be generated/calculated
	var r 
	var g
	var b
	
	var choice = randi()%3 #choose one of three hair colors...
	match(choice):
		0:	
			#GOLDEN HAIR
			r = rand_range(0.85,1)
			g = rand_range(0.7,0.75)
			b = 0

		1:
			#RED HAIR
			#Red between 175 and 255 -> 0.69 and 1
			#Green no more than 125 less than red -> 0.49
			#Green at least 50 less than red -> 0.2
			#No Blue
			r = rand_range(0.69,1)
			g = r - rand_range(0.2,0.49)
			b = 0
		
		2:
			#BLACK HAIR... Kinda color-tinted though
			#Red can go up to 100 -> 0.39
			#Green can only go up to 50 -> 0.2
			#Blue can go up to 100 -> 0.39
			r = rand_range(0,0.39)
			g = rand_range(0,0.2)
			b = rand_range(0,0.39)
	
	var hair_color = Color(r,g,b)
	
	return(hair_color)

#Generate browns for skin colors
#You start with a red between 175 and 245 -> 0.69 to 0.96
#Then a constant delta is subrtracted for green
#Then the same constant delta is subtracted for blue
#Delta goes between 18 and 50 -> 0.07 to 0.2
#BUT!!!!
#Delta should be higher for lower red.... Under 200 -> 0.78
#For lower, delta between 30 and 50 -> 0.12 to 0.2
func generate_skin_color():
	
	var r = rand_range(0.60,0.96)
	var delta #The delta we subtract from r for g, and from g for b
	if r < 0.78:
		delta = rand_range(0.12,0.2)
	else:
		delta = rand_range(0.07,0.2)
	var g = r - delta
	var b = g - delta
	var skin_color = Color(r,g,b)

	return(skin_color)

#A function that converts a given color to pastel...
#It maps the full color RGB values onto
#THe last upper portion of the RGB spectrum (specified by low_grey)
#
#This function used to make metallic/shiny color (like rose gold, silver gold, etc)
#Was also used to make ground seem farther below (keep rising in air from color ground to pure white)
func color_to_pastel(color):
	
	var low_grey = Color(0.75,0.75,0.75)
	var remaining_portions = Color(1-low_grey.r, 1-low_grey.g, 1-low_grey.b) #The last region left to map onto
	
	#Now compute r,g,b values by mapping onto leftover portion
	var r = low_grey.r + ( color.r * remaining_portions.r  )
	var g = low_grey.g + ( color.g * remaining_portions.g  )
	var b = low_grey.b + ( color.b * remaining_portions.b  )	
	
	var pastel_color = Color(r,g,b)
	return(pastel_color)


#Generate reddish browns for dirt
#Basically a hack of generate skin color, but we add more red at the end...
func generate_dirt_color():
	
	var r = rand_range(0.60,0.87)
	var delta #The delta we subtract from r for g, and from g for b
	if r < 0.78:
		delta = rand_range(0.12,0.2)
	else:
		delta = rand_range(0.07,0.2)
	var g = r - delta
	var b = g - delta
	
	#***ALSO add more red
	r = r + rand_range(0,0.13)
	#Alo bllue
	b = b + rand_range(0,0.09)
	
	var skin_color = Color(r,g,b)

	

	return(skin_color)

#A collection of patterns and stuff made by me, MED

#Make a dirt color look wet
#Subtract the following constants from r,g,b:
#respectively: 0.04, 0.16, 0.22
func wet_dirt(dirt_brown):
	var r = dirt_brown.r - 0.04
	var g = dirt_brown.g - 0.16
	var b = dirt_brown.b - 0.22
	
	var wet_dirt_color = Color(r,g,b)
	return(wet_dirt_color)


#A function for generating water colors...
#The colors should be between 75 and 200 ->> 0.29 and 0.78...
#But, BLUE should be highest...
func generate_water_color():
	var b = rand_range(0.32,0.78)
	var r = rand_range(0.3,b)
	var g = rand_range(0.29,r)
	var water_color = Color(r,g,b)
	return(water_color)


	
#A function for generating a LATIN SQUARE
#Based on the input of a string
#Scrambles up the words
#So that each row and column doesn't repeat letters...
#EX. ABCD
#	 BCDA
#	 CDAB
#	 DABC
#
#EX. MAGIC
#	 AICMG
#	 GCMAI
#	 IGACM
#	 CMIGA

#input: size, n dimension, of the latin square to generate
func latinSquare(num_letters):
	
	var return_square = [] #The grid we'll be returning, a list of list. to access use: (r,c)
	
	#var num_letters = letters.length() #the number of letters/columns/rows/n
	
	#Initialize the grid based on number of letters, n
	for i in num_letters: #the rows
		return_square.append([])
		#Also fill in with a dummy character
		for j in num_letters: #the cols
			return_square[i].append('x')
		
	#Start filling in the shit...
	
	#Row By Row, with an offset
	for i in range(num_letters):
		#Fill in row, with offset
		for j in range(num_letters):
			return_square[i][(i+j)%num_letters] = j
	
	
	#Now... shuffle the rows except the very first one
	for i in range(num_letters - 1):
		
		var row_index = i + 1 #the index of swap row, def not first
		
		#decide if we'll move it
		if randi()%2 == 0:
			#Okay, we'll swap then
			var temp_row = return_square[row_index] #temporarily store what was in there...
			
			#randomly choose another row (not the first)
			var choice_row = 1 + randi()%(num_letters-1)
			
			#Now perform the swap
			return_square[row_index] = return_square[choice_row]
			return_square[choice_row] = temp_row
		
		
	return(return_square)
	

#DEMON NAME GEN
#Follows pattern
# cvc-ending
#x. Gofolas or Jakavos
var demon_name_endings = [ "mon", "ur", "aras", "avos", "olas", "ael", "fas", "has", "ok" ]

func genDemonName():
	#pool of letters we pull from
	var consonants = "bcdfghjklmnpqrstvwxyz"
	var vowels = "aeiou"
	
	var name = "" #the name we return
	
	name = name + consonants[randi()%consonants.length()]
	name = name + vowels[randi()%vowels.length()]
	name = name + consonants[randi()%consonants.length()]
	
	name = name + demon_name_endings[randi()%demon_name_endings.size()]
	
	return(name)
