extends Control

func exit():
	queue_free()
	get_parent().back_to_title()
	return
