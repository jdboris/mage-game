extends AudioStreamPlayer

export var audio_streams := []
export var min_interval := 0
export var max_interval := 0
var _index := 0
var _timer := Timer.new()

func _ready() -> void:
	audio_streams.shuffle()
	connect("finished", self, "queue_next")
	
	_timer.connect("timeout", self, "play_next")
	add_child(_timer)
	queue_next()

func queue_next():
	_timer.start(rand_range(min_interval, max_interval))

func play_next():
	if _index == audio_streams.size():
		audio_streams.shuffle()
		_index = 0
	
	stream = audio_streams[_index]
	_index += 1
	
	play()

func _process(delta: float) -> void:
	_timer.paused = stream_paused
