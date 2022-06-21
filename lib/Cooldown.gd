extends Object

var time = 0.0
var max_time = 0.0


func _init(_max_time):
	self.max_time = _max_time
	self.time = 0


func tick(delta):
	time = max(time - delta, 0)


func reset():
	time = max_time


func reset_with_delay(_delay):
	time = min(max_time, _delay)


func is_ready():
	if time > 0:
		return false

	time = max_time
	return true
