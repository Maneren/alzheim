extends Node2D
onready var viewport = get_viewport()

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var base = 0.8
var scl
var resolution = 720

# Called when the node enters the scene tree for the first time.

func _ready():
	viewport.connect("size_changed", self, "window_resize")
	window_resize()
func window_resize():
	scl = base*(OS.window_size.y/resolution)
	self.scale.x = scl
	self.scale.y = scl
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
