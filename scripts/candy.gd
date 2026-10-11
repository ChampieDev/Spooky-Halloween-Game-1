extends Node3D

func set_color(color: Color):
	var mat = $MeshInstance3D.get_surface_override_material(0) as StandardMaterial3D
	mat.albedo_color = color
