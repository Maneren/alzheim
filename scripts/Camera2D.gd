extends Camera2D
var base = 1
var scl
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	print(OS.window_size.y)
	scl = base*(720 / OS.window_size.y)
	$Camera2D.zoom.y = scl
	$Camera2D.zoom.x = scl
 # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
