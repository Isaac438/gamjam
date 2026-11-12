extends Label

const chars_per_second := 10.0
var t := 0.0
var animating := false
var fading := 0

func _process(delta: float) -> void:
	t += delta
	
	if t >= 1.0:
		t = 0.0
		if !animating and global.debug_message != text:
			fade_in()
			while fading == 1:
				await get_tree().process_frame
			animate_text(global.debug_message)
			while animating:
				if get_tree():
					await get_tree().process_frame
				
			await get_tree().create_timer(1.0).timeout
			fade_out()
			
func animate_text(new_text) -> void:
	visible_ratio = 0.0
	text = new_text
	animating = true
	
	
	var tween = create_tween()
	var total_chars = get_total_character_count()
	var duration = total_chars / chars_per_second

	tween.tween_property(self, "visible_ratio", 1.0, duration)
	await(tween.finished)
	animating = false

func fade_in():
	var tween = create_tween()
	
	tween.tween_property(self, "modulate:a", 1, 0.5)
	await tween.finished
	print("done fading in")
	fading = 0
	
func fade_out():
	var tween = create_tween()
	
	tween.tween_property(self, "modulate:a", 0, 0.5)
	await tween.finished
	print("done fading out")
	fading = 0
	
