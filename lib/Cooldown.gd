extends Object

var time = 0.0
var max_time = 0.0


func _init(_max_time):
	self.max_time = _max_time
	self.time = 0


func tick(delta):
	time = max(time - delta, 0)


func is_ready():
	if time > 0:
		return false

	time = max_time
	return true
