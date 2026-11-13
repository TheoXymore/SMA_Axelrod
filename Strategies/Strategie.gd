@abstract
extends Node
class_name Strategie

##La seed utilisée pour le random - si 0, seed aléatoire utilisée
@export var random_seed:int = 0

var rng := RandomNumberGenerator.new()

func _init()->void:
	if random_seed == 0:
		rng.randomize()

enum Choix{
	COOPERER=0,
	DEFERER=1
}

var mesChoix: Array[Choix]
var adversaireChoix: Array[Choix]



##Le nombre de parties gagnées dans le tournois
var scoreTotal:int
##Le nombre parties gagnées dans le BO5
var scoreBO5:int
##Le nombre de points gagnés dans la partie
var scorePartie:int

#Calcul de la moyenne
var scoreMoyen:float = 0
var tours_joues:int = 0

func add_step(step:Vector2i)->void:
	mesChoix.append(step.x)
	adversaireChoix.append(step.y)

func init()-> void:
	scorePartie = 0
	mesChoix.clear()
	adversaireChoix.clear()

##Fonction de sélection de l'action : Déférer ou Coopérer
@abstract
func jouer()->Choix 

func bruit(choix:Choix)->Choix:
	if rng.randi()%20 ==0:
		return Choix.DEFERER if choix == Choix.COOPERER else Choix.COOPERER
	return choix
