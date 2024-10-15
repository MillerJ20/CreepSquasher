extends Label

func _on_mob_squashed():
	GlobalScore.score += GlobalScore.score_increment
	text = "Score: %s" % GlobalScore.score
