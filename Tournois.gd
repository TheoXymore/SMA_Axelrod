extends Node
class_name Tournois

##L'ensemble des joueurs participant au tournois, définis par la stratégie utilisée
@export var Joueurs:Array[Strategie]
##Le nombre de tour que va durer chaque partie
@export var nb_tours:int
##La seed du tournois. Si la seed vaut 0, une seed aléatoire sera sélectionnée
@export var random_seed:int = 0
##Affiche ou non les résultats des parties pendant l'execution
@export var verbeux:bool = true

var duels: Array[Vector2i] = []

func init()->void:
	duels.clear()
	for i in range(Joueurs.size()):
		Joueurs[i].random_seed = random_seed
		Joueurs[i].rng.seed = random_seed
		Joueurs[i].scoreTotal = 0
		Joueurs[i].scoreBO5 = 0
		Joueurs[i].scorePartie = 0
		Joueurs[i].scoreMoyen = 0
		Joueurs[i].tours_joues = 0
		for j in range(i + 1, Joueurs.size()):
			duels.append(Vector2i(i, j))

##Fonction de déroulé du tournois
func tournois()->void:
	init()
	for duel in duels:
		var joueur1 = Joueurs[duel.x]
		var joueur2 = Joueurs[duel.y]
		if verbeux : print("Duel : ", joueur1, " vs ",joueur2, " :")
		#Les scores sont mis à 0
		joueur1.scoreBO5 = 0
		joueur2.scoreBO5 = 0
		var current_manche = 0 #Pour ne pas répéter indéfiniment des parties ex-aequo
		#Lancement d'un BO5 : le premier à 3 manches
		while (joueur1.scoreBO5 <3 and joueur2.scoreBO5<3 and current_manche < 10):
			if verbeux : print("Partie ",current_manche+1," : ")
			var partie:Partie = Partie.new(joueur1,joueur2,nb_tours)
			#Lancement d'une partie
			# output overflow si je mets ça :rofl: if verbeux and current_manche == 0 : partie.partie(true,true)
			partie.partie(verbeux)
			partie.free()
			current_manche+=1
		#Le joueur qui a le plus de points dans le BO5 gagne 1 point dans le tournois
		if joueur1.scoreBO5 > joueur2.scoreBO5:
			if verbeux : 
				print("Victoire de ", joueur1)
				print()
			joueur1.scoreTotal+=1
		elif joueur2.scoreBO5 > joueur1.scoreBO5:
			if verbeux : 
				print("Victoire de ", joueur2)
				print()
			joueur2.scoreTotal+=1
		elif verbeux : 
			print("Egalité ! Personne ne gagne de point")
			print()
	#tri du tableau selon les scores
	for joueur in Joueurs:
		joueur.scoreMoyen /= joueur.tours_joues
	Joueurs.sort_custom(comparer_scores)
	afficher_resultats()
	
func comparer_scores(a: Strategie, b: Strategie) -> bool:
	return a.scoreMoyen > b.scoreMoyen


func afficher_resultats()->void:
	print("Résultats finaux : ")
	for joueur in Joueurs:
		print(joueur, " : ", joueur.scoreMoyen, " points en moyenne, ", joueur.scoreTotal, " victoires")

func _ready()->void:
	tournois()
