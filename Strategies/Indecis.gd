extends Strategie
class_name Indecis

func _to_string() -> String:
	return("Indecis")
	
func jouer()->Choix:
	return Choix.COOPERER if adversaireChoix.size()%2 == 0 else Choix.DEFERER
