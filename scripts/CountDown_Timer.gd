extends Node

var timer
var total_time: int = 60  # Tempo total em segundos (ajuste conforme necessário)
var time_left: int = total_time

func _ready():
	timer = Timer.new()
	timer.connect("timeout", Callable(self, "_on_timer_timeout"))
	timer.set_wait_time(1)  # Define o tempo de espera do timer para 1 segundo
	timer.set_one_shot(false)
	add_child(timer)
	timer.start()
	update_label()  # Atualiza o label inicialmente

func _on_timer_timeout():
	time_left -= 1
	if time_left <= 0:
		timer.stop()
		$Label.text = "Perdeu a vez"  # Exibe a mensagem quando o tempo acabar
	else:
		update_label()  # Atualiza o label com o tempo restante

func update_label():
	var minutes = floor(time_left / 60)
	var seconds = time_left % 60
	$Label.text = "%02d:%02d" % [minutes, seconds]
