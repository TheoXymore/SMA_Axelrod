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

var Gains:Array[Array]

signal message(texte:String)

func ecrire(...args:Array)->void:
	message.emit("".join(PackedStringArray(args.map(str))))

func _init(joueur1:Strategie,joueur2:Strategie,tours:int,gains:Array[Array]) -> void:
	Gains = gains
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
			ecrire(Joueur1, "choisit ", "D" if choixJ1 == Choix.DEFERER else "C")
			ecrire(Joueur2, "choisit ", "D" if choixJ2 == Choix.DEFERER else "C")
		
		Joueur1.adversaireChoix.append(choixJ2)
		Joueur2.adversaireChoix.append(choixJ1)
		
		#Au cas où j'ai besoin du déroulé plus tard
		var step:Vector2i = Vector2i(choixJ1,choixJ2)
		deroule.append(step)
		
		Joueur1.tours_joues+=1
		Joueur2.tours_joues+=1
		
		#En fonction des deux actions, les joueurs gagnent des points selon la matrice de gains
		Joueur1.add_score(Gains[choixJ1][choixJ2].x)
		Joueur2.add_score(Gains[choixJ1][choixJ2].y)
		

	if verbeux :
		ecrire(Joueur1," : ", Joueur1.scorePartie)
		ecrire(Joueur2, " : ", Joueur2.scorePartie)
	if Joueur1.scorePartie > Joueur2.scorePartie:
		Joueur1.scoreBO5+=1
	elif Joueur2.scorePartie > Joueur1.scorePartie:
		Joueur2.scoreBO5+=1
		
	
