extends Node

var mage
var wave_count := 0
var wave_interval := 5.0

var wave_limit := 99
var wave_goal := 35
var is_playing := false


func _ready() -> void:
	randomize()


func start_level() -> void:
	is_playing = true
	$MusicPlayer.stream.loop = false
	$MusicPlayer.play(1)
	$RoarPlayer.play()
	
	for mob in $Mobs.get_children():
		mob.queue_free()
	
	$Hud/WaveLabel.text = ""
	$Hud/AlertLabel.text = "Survive " + str(wave_goal) + "+ waves to win..."
	$Hud/AlertLabel.add_color_override("font_color", Color("931818"))
	$Hud/AlertLabel.show()
	var timer := get_tree().create_timer(5)
	timer.connect("timeout", self, "clear_alert")
	
	wave_count = 0
	
	mage = preload("res://mobs/mage.tscn").instance()
	$Mobs.add_child(mage)
	mage.get_node("Props/Health").connect("value_changed", self, "end_level")
	
	$UnitHud.mob = mage
	$UnitHud/UpdateTimer.start()
	
	$SpawnTimer.start(wave_interval)

func clear_alert():
	$Hud/AlertLabel.text = ""
	$Hud/AlertLabel.hide()

func end_level(old_value, prop):
	if prop.value <= 0:
		is_playing = false
		$Hud/AlertLabel.text = "You Win!\n" if wave_count >= wave_goal else "Game Over\n"
		$Hud/AlertLabel.text += "Score: " + str(wave_count)
		$Hud/AlertLabel.add_color_override("font_color", Color("00FF00") if wave_count >= wave_goal else Color("931818"))
		$Hud/AlertLabel.show()
		Global.pause_scene($Mobs, true)
		$MainMenu.show()
		$SpawnTimer.stop()
		$UnitHud/UpdateTimer.stop()
		$MusicPlayer.seek(118)


func spawn_wave():
	$SpawnTimer.wait_time = $SpawnTimer.wait_time if $SpawnTimer.wait_time <= 2.2 else $SpawnTimer.wait_time - 0.1
	wave_count += 1
	
	if wave_count > wave_limit:
		$SpawnTimer.stop()
		return
		
	$Hud/WaveLabel.text = "Wave: " + str(wave_count)
	
	var formations = [
		preload("res://mob_groups/skeleton_warrior_group.tscn"), 
		preload("res://mob_groups/skeleton_warrior_line.tscn"), 
		preload("res://mob_groups/skeleton_giant.tscn")
	]
	
	var angle := rand_range(0, 359)
	var distance := 27

	var direction := Vector3.FORWARD.rotated(Vector3.UP, deg2rad(angle))
	var spawn_point := direction * distance

	var formation = formations[randi() % formations.size()].instance()
	$Mobs.add_child(formation)
	formation.global_translate(spawn_point)
	formation.look_at(Vector3(0, 0, 0), Vector3.UP)

	# Initial aggro
	for mob in formation.get_children():
		mob.get_node("MeleeAiInput").target = mage.get_node("MobHurtbox")


func _process(delta: float) -> void:
	if is_playing and $MusicPlayer.get_playback_position() >= 118:
		$MusicPlayer.seek(20.4)
