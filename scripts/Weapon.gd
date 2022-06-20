extends Node2D


func _ready():
	pass  # Replace with function body.


func _on_WeaponHitBox_area_entered(area: Area2D):
	if area.name == "HitBox" and self.owner.name != area.owner.name:
		area.owner.take_damage(self.owner.attack_damage)
