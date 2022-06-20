extends Node2D


func _on_WeaponHitBox_body_entered(body):
	print(self.owner.name, body.name, self.owner.name.split("_")[0], body.name.split("_")[0])
	if self.owner.name != body.name and self.owner.name.split("_")[0] != body.name.split("_")[0]:
		body.take_damage(self.owner.attack_damage)
