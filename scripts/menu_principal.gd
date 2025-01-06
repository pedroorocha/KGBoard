extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_jogadores_pressed() -> void:
	$PopupJogadores.popup_centered()
	pass # Replace with function body.


func _on_regras_pressed() -> void:
	$PopupRegras.popup_centered()
	pass # Replace with function body.


func _on_voltar_pressed() -> void:
	$PopupRegras.hide()
	pass # Replace with function body.


func _on_iniciar_jogo_pressed() -> void:
	var jogadores = $PopupJogadores/HBoxContainer/OptionButton.get_selected_id() + 2
	get_tree().change_scene("res://scenes/tabuleiro.tscn")
	pass # Replace with function body.
