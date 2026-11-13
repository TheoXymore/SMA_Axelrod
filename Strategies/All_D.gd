extends Strategie
class_name All_D

func jouer()->Choix:
	return Choix.DEFERER
	
func _to_string() -> String:
	return("ALL-D")
