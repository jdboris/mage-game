extends Spatial

func _on_Health_value_changed(old_value, prop) -> void:
	
	var width = max(1, prop.value / (prop.max_value - prop.min_value) * $HealthBar.texture.get_width())
	var offset = -($HealthBar.texture.get_width() - width) / 2
	
	$HealthBar.region_rect = Rect2(
		0, 
		0, 
		width, 
		$HealthBar.texture.get_height()
	)
	
	$HealthBar.offset.x = offset

