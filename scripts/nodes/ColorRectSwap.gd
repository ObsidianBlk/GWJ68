extends ColorRect


# ------------------------------------------------------------------------------
# Override Methods
# ------------------------------------------------------------------------------
func _ready() -> void:
	Pal.palette_changed.connect(_on_palette_changed)

# ------------------------------------------------------------------------------
# Private Methods
# ------------------------------------------------------------------------------
func _SetMaterialPalette(tex : Texture) -> void:
	if material is ShaderMaterial and tex != null:
		material.set_shader_parameter("new_palette", tex)

# ------------------------------------------------------------------------------
# Handler Methods
# ------------------------------------------------------------------------------
func _on_palette_changed(palidx : int) -> void:
	_SetMaterialPalette(Pal.get_palette_texture(palidx))
