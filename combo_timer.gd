extends TextureProgressBar
var combotTimes = { 2: 1.3, 4: 1.1, 8: 0.9, 16: 0.7, 32: 0.6 }
var canStartTimer = false

func startComboTimer():
	#only start the timer if bool is true (prevents multiple starts of timer)
	if(canStartTimer):
		print("Starting timer")
		$ComboTimer.start(combotTimes[GlobalScore.score_increment])
		canStartTimer = false

func stopComboTimer():
	$ComboTimer.stop()

func isTimerPaused():
	return $ComboTimer.is_paused()

func pauseComboTimer():
	$ComboTimer.set_paused(true)

func unPauseComboTimer():
	$ComboTimer.set_paused(false)

func _on_combo_timer_timeout() -> void:
	print("Timer finished")
	canStartTimer = false
	GlobalScore.score_increment = 1
