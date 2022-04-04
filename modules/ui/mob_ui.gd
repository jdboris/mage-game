extends Spatial

func _on_Health_value_changed(old_value, prop) -> void:
	$Viewport/Wrapper/HealthBar.max_value = prop.max_value
	$Viewport/Wrapper/HealthBar.min_value = prop.min_value
	$Viewport/Wrapper/HealthBar.value = prop.value
