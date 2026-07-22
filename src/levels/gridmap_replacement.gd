extends GridMap

@export var rules: Array[GridMapReplacementRule] = []

func _ready() -> void:
	replace_items()

func replace_items() -> void:
	if mesh_library == null:
		return

	# Build lookup dictionary
	var lookup := {}

	for rule in rules:
		if rule and rule.target_name != "" and rule.replacement_scene:
			lookup[rule.target_name] = rule.replacement_scene

	for cell in get_used_cells():
		var item_id := get_cell_item(cell)

		if item_id == INVALID_CELL_ITEM:
			continue

		var item_name := mesh_library.get_item_name(item_id)

		if not lookup.has(item_name):
			continue

		var scene: PackedScene = lookup[item_name]
		var instance = scene.instantiate()

		# Position
		var world_pos := to_global(map_to_local(cell))

		# Rotation
		var orientation := get_cell_item_orientation(cell)
		var cell_basis := get_basis_with_orthogonal_index(orientation)

		instance.global_transform = Transform3D(cell_basis, world_pos)

		get_parent().add_child.call_deferred(instance)

		set_cell_item(cell, INVALID_CELL_ITEM)
