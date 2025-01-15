extends Object

class_name Posicao

# Classe Posicao
var pos: Vector2
var forma_geometrica: String

func _init(pos: Vector2, forma_geometrica: String) -> void:
	self.pos = pos
	self.forma_geometrica = forma_geometrica

func get_position() -> Dictionary:
	return {
		"pos": pos,
		"forma_geometrica": forma_geometrica
	}
