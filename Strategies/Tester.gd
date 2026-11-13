extends Strategie
class_name Tester

var tft:bool = false

func init()->void:
	super.init()
	tft = false

func _to_string() -> String:
	return ("TESTER")

func jouer()->Choix:
	#Tour 1 :
	if mesChoix.size()==0:
		return Choix.DEFERER
		
	#Tours suivants :
	var choix:Choix
	if tft:
		choix = adversaireChoix[-1]
	else : 
		if mesChoix.size()%3 == 0:
			choix = Choix.DEFERER
		else : 
			choix = Choix.COOPERER
	#Si l'adversaire a joué D :
	if adversaireChoix[-1] == Choix.DEFERER:
		tft = true
		
	return choix
