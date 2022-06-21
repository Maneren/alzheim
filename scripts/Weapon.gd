extends Node2D


func _on_WeaponHitBox_body_entered(body):
	if (
		(body.name == "Player" or "_" in body.name)
		and self.owner.name != body.name
		and self.owner.name.split("_")[0] != body.name.split("_")[0]
	):
		body.take_damage(self.owner.attack_damage, self.owner.name)
