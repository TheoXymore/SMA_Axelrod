extends Strategie
class_name Pigeon

func _to_string() -> String:
	return("Pigeon")

func jouer()->Choix:
	return Choix.COOPERER
