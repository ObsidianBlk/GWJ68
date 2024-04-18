extends ColorRect
class_name ColorRectSwap


# ------------------------------------------------------------------------------
# Override Methods
# ------------------------------------------------------------------------------
func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	Pal.palette_changed.connect(_on_palette_changed)
	Pal.palette_inverted.connect(_on_palette_inverted)
	var palidx : int = Pal.get_current_palette_index()
	_SetMaterialPalette(Pal.get_palette_texture(palidx), Pal.is_palette_inverted())

# ------------------------------------------------------------------------------
# Private Methods
# ------------------------------------------------------------------------------
func _SetMaterialPalette(tex : Texture, inverted : bool = false) -> void:
	if material is ShaderMaterial and tex != null:
		material.set_shader_parameter("new_palette", tex)
		material.set_shader_parameter("invert", inverted)

# ------------------------------------------------------------------------------
# Handler Methods
# ------------------------------------------------------------------------------
func _on_palette_changed(palidx : int) -> void:
	_SetMaterialPalette(Pal.get_palette_texture(palidx), Pal.is_palette_inverted())

func _on_palette_inverted(inverted : bool) -> void:
	var palidx : int = Pal.get_current_palette_index()
	_SetMaterialPalette(Pal.get_palette_texture(palidx), inverted)
