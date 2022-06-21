extends Sprite


func _input(event):
	if event is InputEventKey and event.pressed and event.scancode == KEY_F1:
		self.visible = not self.visible
