extends Node2D

# Alterar pergunta, alternativas, id do jogador, respostas corretas
var pergunta = ""
var alternativas = []
var resposta_correta = []
var cor = "Vez do peão "
#1 se tiver acertado
var is_correct = 0
signal carta_finalizada

@onready var label_pergunta = $Label
@onready var label_vez = $Label2
@onready var alternativas_container = $GridContainer
@onready var botao_confirmar = $Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pergunta = get_tree().root.get_meta("pergunta")
	alternativas = get_tree().root.get_meta("alternativas")
	resposta_correta = get_tree().root.get_meta("resposta_correta")
	cor += get_tree().root.get_meta("cor")
	# Configura os elementos da carta
	label_pergunta.text = pergunta  # Define o texto da pergunta
	label_vez.text = cor
	if cor == "Vez do peão Vermelho":
		print(cor)
		label_vez.modulate = Color(1, 0, 0)
	elif cor == "Vez do peão Preto":
		label_vez.modulate = Color(0, 0, 0)
	elif cor == "Vez do peão Azul":
		label_vez.modulate = Color(0, 0, 1)
	elif cor == "Vez do peão Branco":
		label_vez.modulate = Color(1, 1, 1)
	for alternativa in alternativas:
		var checkbox = CheckBox.new()
		checkbox.text = alternativa
		alternativas_container.add_child(checkbox)

# Função chamada para verificar e desmarcar checkboxes
func check_and_uncheck() -> void:
	for i in range(alternativas_container.get_child_count()):
		var child = alternativas_container.get_child(i)
		if child is CheckBox:
			if child.is_pressed():  # Se o checkbox estiver marcado
				# Desmarque todos os outros checkboxes
				for j in range(alternativas_container.get_child_count()):
					var other_child = alternativas_container.get_child(j)
					if other_child is CheckBox and other_child != child:
						other_child.set_pressed(false)

# Função chamada quando o estado de um checkbox é alterado
func _process(delta: float) -> void:
	# Verifique todos os checkboxes a cada frame
	check_and_uncheck()
	
# Função chamada ao pressionar o botão
func _on_button_pressed() -> void:
	for i in range(alternativas_container.get_child_count()):
		var child = alternativas_container.get_child(i)
		if child is CheckBox and child.is_pressed():
			for alternativa_correta in resposta_correta:
				print(alternativa_correta)
				if child.text == alternativa_correta:
					print("Jogador acertou!")
					#emit_signal("jogador_acertou", jogador_id)  # Emitir um sinal, por exemplo
					emit_signal("carta_finalizada")
					queue_free()
					is_correct = 1
					get_tree().root.set_meta("is_correct", is_correct)
					return 
	print("Jogador errou!")
	#emit_signal("jogador_errou", jogador_id)  # Emitir um sinal, por exemplo
	emit_signal("carta_finalizada")
	queue_free()
	get_tree().root.set_meta("is_correct", is_correct)
	return
