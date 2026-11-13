extends Strategie
class_name TitForTat

func _to_string() -> String:
	return ("TIT-FOR-TAT")

func jouer()->Choix:
	if adversaireChoix.size() == 0:
		return Choix.COOPERER
	else :
		return adversaireChoix[-1]
