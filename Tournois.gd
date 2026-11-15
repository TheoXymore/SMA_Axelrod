extends Node
class_name Tournois

##L'ensemble des joueurs participant au tournois, définis par la stratégie utilisée
#Enlevé pour utiliser plutot l'arborescence
#@export var Joueurs:Array[Strategie]
##Le nombre de tour que va durer chaque partie
@export var nb_tours:int
##La seed du tournois. Si la seed vaut 0, une seed aléatoire sera sélectionnée
@export var random_seed:int = 0
##Affiche ou non les résultats des parties pendant l'execution
@export var verbeux:bool = true

signal message(texte:String)

var Gains:Array[Array] = [
	[Vector2i(3,3),Vector2i(0,5)],
	[Vector2i(5,0),Vector2i(2,2)]
]

### PARTIE AJOUTEE AVEC CLAUDE POUR AVOIR UN EXECUTABLE ET LANCER DIFFERENTES SIMULATIONS

func get_joueurs() -> Array[Strategie]:
	var res: Array[Strategie] = []
	for c in get_children():
		if c is Strategie:
			res.append(c)
	return res

## FIN DE LA PARTIE AJOUTEE PAR CLAUDE
var duels: Array[Vector2i] = []

func init()->void:
	duels.clear()
	for i in range(get_child_count()):
		if random_seed == 0:
			get_child(i).rng.randomize()
		else :
			get_child(i).rng.seed = random_seed
			
		get_child(i).score = 0
		get_child(i).scoreTotal = 0
		get_child(i).scoreBO5 = 0
		get_child(i).scorePartie = 0
		get_child(i).scoreMoyen = 0
		get_child(i).tours_joues = 0
		for j in range(i + 1, get_child_count()):
			duels.append(Vector2i(i, j))
			
func ecrire(...args: Array) -> void:
	var morceaux := PackedStringArray()
	for a in args:
		morceaux.append(str(a))
	var texte := "".join(morceaux)
	print(texte)
	message.emit(texte)

##Fonction de déroulé du tournois
func tournois()->void:
	init()
	for duel in duels:
		var joueur1 = get_child(duel.x)
		var joueur2 = get_child(duel.y)
		if verbeux : ecrire("Duel : ", joueur1, " vs ",joueur2, " :")
		#Les scores sont mis à 0
		joueur1.scoreBO5 = 0
		joueur2.scoreBO5 = 0
		var current_manche = 0 #Pour ne pas répéter indéfiniment des parties ex-aequo
		#Lancement d'un BO5 : le premier à 3 manches
		while (joueur1.scoreBO5 <3 and joueur2.scoreBO5<3 and current_manche < 5):
			if verbeux : ecrire("Partie ",current_manche+1," : ")
			var partie:Partie = Partie.new(joueur1,joueur2,nb_tours,Gains)
			partie.message.connect(ecrire)
			#Lancement d'une partie
			# output overflow si je mets ça :rofl: if verbeux and current_manche == 0 : partie.partie(true,true)
			partie.partie(verbeux)
			partie.free()
			current_manche+=1
		#Le joueur qui a le plus de points dans le BO5 gagne 1 point dans le tournois
		if joueur1.scoreBO5 > joueur2.scoreBO5:
			if verbeux : 
				ecrire("Victoire de ", joueur1)
				ecrire()
			joueur1.scoreTotal+=1
		elif joueur2.scoreBO5 > joueur1.scoreBO5:
			if verbeux : 
				ecrire("Victoire de ", joueur2)
				ecrire()
			joueur2.scoreTotal+=1
		elif verbeux : 
			ecrire("Egalité ! Personne ne gagne de point")
			ecrire()
		await get_tree().process_frame
	#tri du tableau selon les scores
	for joueur in get_children():
		joueur.scoreMoyen = float(joueur.score) / joueur.tours_joues
		
	#Affichage des score selon différents classements : 
	ecrire("Résultats finaux : ")
	ecrire()

	ecrire("Classement des scores : ")
	afficher_resultats(tri_scores(get_children(),comparer_scores))
	ecrire()
	
	ecrire("Classement des moyennes : ")
	afficher_resultats(tri_scores(get_children(),comparer_scores_moyen))
	ecrire()
	
	ecrire("Classement des victoires : ")
	afficher_resultats(tri_scores(get_children(),comparer_scores_victoire))
	
	
func tri_scores(tableau: Array[Node], tri : Callable)->Array[Node]:
	var tab2:Array[Node] = tableau
	tab2.sort_custom(tri)
	return tab2
	

func comparer_scores(a: Strategie, b: Strategie) -> bool:
	return a.score > b.score
	
func comparer_scores_moyen(a: Strategie, b: Strategie) -> bool:
	return a.scoreMoyen > b.scoreMoyen
	
func comparer_scores_victoire(a: Strategie, b: Strategie) -> bool:
	return a.scoreTotal > b.scoreTotal


func afficher_resultats(Joueurs:Array[Node])->void:
	for joueur in Joueurs:
		ecrire(joueur, " : ",joueur.score, " points, ", "%.3f" % joueur.scoreMoyen, " points en moyenne, ", joueur.scoreTotal, " victoires")
