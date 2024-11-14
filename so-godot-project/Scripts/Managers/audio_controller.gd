extends AudioStreamPlayer

const menu_music = preload("res://Assets/Audio/menu_loop.mp3")
const game_music_1 = preload("res://Assets/Audio/game_music1.mp3")

const DEFAULT_VOLUME = -14.0
const DAMPENED_VOLUME = -30.0  # Lower volume for paused state

func play_music(music: AudioStream, volume = -14.0):
	if stream == music:
#		if music of playing, then dont need to do anything
		return
	stream = music
	volume_db = volume
	play()


#quick funcions so can be called wherever 
func play_menu_music():
	play_music(menu_music)

func play_game_music():
	play_music(game_music_1)
	
func set_paused(is_paused: bool):
	volume_db = DAMPENED_VOLUME if is_paused else DEFAULT_VOLUME
