#
# Individual piece logic
#

extends Area2D

var color
var pos
var selected = false

onready var sprite_nd = get_node("sprite")
onready var board_nd = get_node("../board")

# Material gets duplicated to allow different shaders on
# multiple instances of scene
onready var piece_material = sprite_nd.get_material().duplicate()
var outline_shader = preload("outline_shader.xml")
var empty_shader = preload("empty_shader.xml")


# Handles click on piece - updates global state
func _input_event(viewport, event, shape_idx):
	if event.type == InputEvent.MOUSE_BUTTON \
	and event.button_index == BUTTON_LEFT \
	and event.pressed:
		global.selected_piece_name = self.get_name()
		global.selected_piece_pos = board_nd.world_to_map(pos)
		global.selected_piece_color = color


func _mouse_enter():
	sprite_nd.set_scale(Vector2(1.1, 1.1))


func _mouse_exit():
	sprite_nd.set_scale(Vector2(1, 1))


func _ready():
	self.set_process(true)
	
	# Material to hold shader
	sprite_nd.set_material(piece_material)
	sprite_nd.get_material().set_shader(empty_shader)


func _process(delta):
	pos = self.get_pos()
	
	if global.selected_piece_name == self.get_name():
		selected = true
	else:
		selected = false
	
	# Visual selection
	if selected:
		piece_material.set_shader(outline_shader)
	else:
		piece_material.set_shader(empty_shader)
		