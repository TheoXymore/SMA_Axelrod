extends Strategie
class_name Joss

		
func _to_string() -> String:
	return ("JOSS")
		

func jouer()->Choix:
	var choix:Choix
	if mesChoix.size()==0:
		choix = Choix.COOPERER
	else :
		choix = adversaireChoix[-1]
	
	if choix == Choix.COOPERER and rng.randi() % 10 == 0:
		choix = Choix.DEFERER
		
	return choix
