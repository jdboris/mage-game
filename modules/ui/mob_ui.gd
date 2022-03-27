extends Spatial

export var health_node_path: NodePath

func _ready():
	var health_node: = get_node(health_node_path)
	$Viewport/Wrapper/HealthBar.max_value = health_node.max_value
	$Viewport/Wrapper/HealthBar.min_value = health_node.min_value
	$Viewport/Wrapper/HealthBar.value = health_node.value
	var error = health_node.connect("value_changed", self, "_on_health_changed")
	assert(!error, error)

func _on_health_changed(old_value, new_value):
	$Viewport/Wrapper/HealthBar.value = new_value
