extends Node
class_name Partie

const Choix = Strategie.Choix
const C = Choix.COOPERER
const D = Choix.DEFERER

##Stratégie utilisée par le joueur 1
var Joueur1 : Strategie
##Stratégie utilisée par le joueur 2
var Joueur2 : Strategie
##Nombre de tours de la partie
var nb_tours : int = 200

var deroule:Array[Vector2i]

func _init(joueur1:Strategie,joueur2:Strategie,tours:int) -> void:
	Joueur1 = joueur1
	Joueur2 = joueur2
	nb_tours = tours
	Joueur1.init()
	Joueur2.init()
	

##fonction de déroulé d'une partie
func partie(verbeux:bool=true, verbeux_max:bool = false)->void:
	#Début d'une partie
	for i in range(nb_tours):
		#Les joueurs sélectionnent leur action
		var choixJ1:Choix = Joueur1.bruit(Joueur1.jouer())
		var choixJ2:Choix = Joueur2.bruit(Joueur2.jouer())
		if verbeux_max :
			print(Joueur1, "choisit ", "D" if choixJ1 == Choix.DEFERER else "C")
			print(Joueur2, "choisit ", "D" if choixJ2 == Choix.DEFERER else "C")
		
		var step:Vector2i = Vector2i(choixJ1,choixJ2)
		Joueur1.add_step(step)
		Joueur2.add_step(Vector2i(choixJ2,choixJ1))
		deroule.append(step)
		Joueur1.tours_joues+=1
		Joueur2.tours_joues+=1
		#En fonction des deux actions, les joueurs gagnent des points
		match step:
			Vector2i(C,C):
				Joueur1.scorePartie += 3
				Joueur1.scoreMoyen +=3
				Joueur2.scorePartie += 3
				Joueur2.scoreMoyen +=3
			Vector2i(C,D):
				Joueur1.scorePartie += 0
				Joueur1.scoreMoyen +=0
				Joueur2.scorePartie += 5
				Joueur2.scoreMoyen +=5
			Vector2i(D,C):
				Joueur1.scorePartie += 5
				Joueur1.scoreMoyen +=5
				Joueur2.scorePartie += 0
				Joueur2.scoreMoyen +=0
			Vector2i(D,D):
				Joueur1.scorePartie += 2
				Joueur1.scoreMoyen +=2
				Joueur2.scorePartie += 2
				Joueur2.scoreMoyen +=2
	if verbeux :
		print(Joueur1," : ", Joueur1.scorePartie)
		print(Joueur2, " : ", Joueur2.scorePartie)
	if Joueur1.scorePartie > Joueur2.scorePartie:
		Joueur1.scoreBO5+=1
	elif Joueur2.scorePartie > Joueur1.scorePartie:
		Joueur2.scoreBO5+=1
		
	
