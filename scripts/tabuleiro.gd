extends Node2D
# Variáveis para o tabuleiro e os peões
@export var pawn_scene: PackedScene  # Arraste a cena "peao.tscn" para esta propriedade no editor.
var pawn_positions = []  # Lista para armazenar posições iniciais para os peões.
var cores = ["Vermelho", "Azul", "Preto", "Branco"]
var id_passados = {}
var indices_jogadores = []
var ultimo_indice = 0
var pergunta = ""
var alternativas = []
var resposta_correta = []
var cor = ""
func _ready() -> void:
	# Defina as posições iniciais dos peões no tabuleiro.
	# Ajuste estas coordenadas com base no layout do tabuleiro.
	pawn_positions = [
		Vector2(40, 50),
		Vector2(50, 50),
		Vector2(60, 50),
		Vector2(70, 50)
	]
	
	# Chama a função para adicionar os peões (modifique conforme o número de jogadores).
	var jogadores = get_tree().root.get_meta("jogadores")
	add_pawns(jogadores)

# Função para adicionar os peões ao tabuleiro
func add_pawns(player_count: int) -> void:
	for i in range(player_count):
		indices_jogadores.append(i)
		var pawn = pawn_scene.instantiate()  # Instancia a cena do peão
		pawn.position = pawn_positions[i]  # Define a posição inicial
		$Peoes.add_child(pawn)
		for j in range(4):  # A cena do peão tem 4 sprites
			var sprite = pawn.get_node(cores[j])  # Considerando que seus sprites são nomeados "Sprite1", "Sprite2", etc.
			if j == i:  # Se o índice do sprite for maior que o número de jogadores, esconda
				sprite.visible = true
			else:
				sprite.visible = false

#Função para sortear uma questão
func random_question(temas, indices_jogadores, ultimo_indice) -> void:
	var tamanho_vetor = temas.size() - 1
	var rng = RandomNumberGenerator.new()
	var number = rng.randi_range(0, tamanho_vetor)
	var tema = temas[number]
	var path = "questions/" + tema + ".json"
	var questoes = carregar_json(path)
	
	if questoes.size() > 0:  # Verifica se há questões carregadas
		var verificador = false
		while not verificador:
			var questao_sorteada = questoes[rng.randi_range(0, questoes.size() - 1)]
			if questao_sorteada["tema"] not in id_passados:
				verificador = true
				_process_question(questao_sorteada, ultimo_indice)
				if ultimo_indice == indices_jogadores.size()-1:
					ultimo_indice = 0
				else:
					ultimo_indice += 1
			elif questao_sorteada["tema"] in id_passados:
				if questao_sorteada["id"] not in id_passados[questao_sorteada["tema"]]:
					verificador = true
					_process_question(questao_sorteada, ultimo_indice)
					ultimo_indice = (ultimo_indice + 1) % indices_jogadores.size()
				else:
					if questoes.size() == id_passados[questao_sorteada["tema"]].size():
						id_passados[questao_sorteada["tema"]] = []
	else:
		print("Nenhuma questão encontrada para o tema:", tema)

func _process_question(questao_sorteada, ultimo_indice):
	# Processa a questão e define as propriedades no nó root
	pergunta = questao_sorteada["pergunta"]
	get_tree().root.set_meta("pergunta", pergunta)
	alternativas = questao_sorteada["alternativas"]
	get_tree().root.set_meta("alternativas", alternativas)
	resposta_correta = questao_sorteada["resposta_correta"]
	get_tree().root.set_meta("resposta_correta", resposta_correta)
	cor = cores[ultimo_indice]
	get_tree().root.set_meta("cor", cor)

	# Carrega e instancia a cena da carta
	var carta_scene = preload("res://scenes/carta.tscn")
	var carta = carta_scene.instantiate()

	if carta != null:
		# Adiciona a carta como filho da cena atual
		var current_scene = get_tree().current_scene
		if current_scene != null:
			current_scene.add_child(carta)
			# Posicione a carta, se necessário
			carta.position = Vector2(50, 25)  # Ajuste conforme necessário
			carta.z_index = 1  # Garante que fique acima de outros elementos
		else:
			print("Erro: Cena atual não encontrada.")
	else:
		print("Erro: Não foi possível instanciar a carta.")
func mover_peao(indices_jogadores, ultimo_indice) -> void:
	pass
	
func carregar_json(caminho: String) -> Array:
	# Abre o arquivo JSON
	var file = FileAccess.open(caminho, FileAccess.READ)
	var conteudo = file.get_as_text()  # Lê o conteúdo do arquivo como texto
	file.close()  # Fecha o arquivo
	var resultado = JSON.parse_string(conteudo)
	return resultado


func _on_button_pressed() -> void:
	var temas_selecionados = get_tree().root.get_meta("temas")
	random_question(temas_selecionados,indices_jogadores, ultimo_indice)
	pass # Replace with function body.
