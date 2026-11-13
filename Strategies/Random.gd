extends Strategie
class_name Random

		
func _to_string() -> String:
	return ("RANDOM")

func jouer()->Choix:
	return Choix.COOPERER if rng.randi() % 2 == 0 else Choix.DEFERER
