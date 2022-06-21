extends KinematicBody2D

var moving = 0


func _on_Area2D_area_shape_entered(_area_rid, area: Area2D, _area_shape_index, _local_shape_index):
	if area.owner.name == "Player":
		print("Player entered area")
		if area.owner.finished_bard_quests.size() == 4:
			print("Opening")
			moving = 1


func _on_Area2D_area_shape_exited(_area_rid, area: Area2D, _area_shape_index, _local_shape_index):
	if area.owner.name == "Player":
		print("Player exited area")
		print("Closing")
		moving = -1


func _process(delta):
	self.position.x += moving * delta * 200
	self.position.x = clamp(self.position.x, 0, 1024)
