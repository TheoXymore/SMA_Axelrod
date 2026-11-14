extends Control

##SCRIPT CREE A L'AIDE DE CLAUDE POUR FAIRE L'EXECUTABLE

const STRATEGIES: Dictionary = {
	"ALL-D": preload("res://Strategies/All_D.gd"),
	"TIT-FOR-TAT": preload("res://Strategies/Tit_for_tat.gd"),
	"RANDOM": preload("res://Strategies/Random.gd"),
	"JOSS": preload("res://Strategies/Joss.gd"),
	"TESTER": preload("res://Strategies/Tester.gd"),
	"PIGEON": preload("res://Strategies/Pigeon.gd"),
	"INDECIS": preload("res://Strategies/Indecis.gd"),
}

const NOMS_CHOIX: Array[String] = ["C", "D"]

## champs[mon_choix][son_choix] = [SpinBox pour le gain J1, SpinBox pour le gain J2]
var champs: Array = [[null, null], [null, null]]

@onready var tournois: Tournois = $Tournois

func _ready() -> void:
	for nom in STRATEGIES:
		var b := Button.new()
		b.text = "+ " + nom
		b.pressed.connect(ajouter_joueur.bind(nom))
		$HBoxContainer/ListeDispo.add_child(b)
	tournois.message.connect(afficher_message)
	$HBoxContainer/VBoxContainer/BoutonLancer.pressed.connect(lancer)
	rafraichir_joueurs()
	
	$"HBoxContainer/Paramètres/Tours/SpinTours".value = tournois.nb_tours
	$"HBoxContainer/Paramètres/Seed/SpinSeed".value = tournois.random_seed
	
	construire_matrice()
	
func construire_matrice() -> void:
	var defauts := [
		[Vector2i(3, 3), Vector2i(0, 5)],
		[Vector2i(5, 0), Vector2i(2, 2)],
	]
	var grille := GridContainer.new()
	grille.columns = 3
	grille.add_theme_constant_override("h_separation", 12)
	$"HBoxContainer/Paramètres/Gains".add_child(grille)

	# Ligne d'en-tête : case vide, puis les choix du joueur 2
	grille.add_child(Control.new())
	for j in 2:
		grille.add_child(creer_entete(NOMS_CHOIX[j]))

	for i in 2:
		# En-tête de ligne : le choix du joueur 1
		grille.add_child(creer_entete(NOMS_CHOIX[i]))
		for j in 2:
			var cellule := HBoxContainer.new()
			cellule.add_theme_constant_override("separation", 2)
			var gx := creer_champ(defauts[i][j].x)
			var gy := creer_champ(defauts[i][j].y)
			var virgule := Label.new()
			virgule.text = ","
			cellule.add_child(gx)
			cellule.add_child(virgule)
			cellule.add_child(gy)
			grille.add_child(cellule)
			champs[i][j] = [gx, gy]

func creer_entete(texte: String) -> Label:
	var l := Label.new()
	l.text = texte
	l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	return l

func creer_champ(valeur: int) -> LineEdit:
	var e := LineEdit.new()
	e.text = str(valeur)
	e.custom_minimum_size = Vector2(20, 0)
	e.alignment = HORIZONTAL_ALIGNMENT_CENTER
	e.select_all_on_focus = true
	return e

## Renvoie la matrice saisie, ou un tableau vide si une case n'est pas un entier
func lire_gains() -> Array[Array]:
	var gains: Array[Array] = []
	for i in 2:
		var ligne: Array = []
		for j in 2:
			var tx: String = champs[i][j][0].text.strip_edges()
			var ty: String = champs[i][j][1].text.strip_edges()
			if not (tx.is_valid_int() and ty.is_valid_int()):
				return []
			ligne.append(Vector2i(tx.to_int(), ty.to_int()))
		gains.append(ligne)
	return gains
	
func afficher_message(texte:String) -> void:
	$HBoxContainer/Sortie.append_text(texte + "\n")

func ajouter_joueur(nom: String) -> void:
	tournois.add_child(STRATEGIES[nom].new())
	rafraichir_joueurs()

func retirer_joueur(s: Strategie) -> void:
	tournois.remove_child(s)
	s.queue_free()
	rafraichir_joueurs()

func rafraichir_joueurs() -> void:
	for c in $HBoxContainer/ListeJoueurs.get_children():
		c.queue_free()
	for s in tournois.get_joueurs():
		var b := Button.new()
		b.text = "✕ " + str(s)
		b.pressed.connect(retirer_joueur.bind(s))
		$HBoxContainer/ListeJoueurs.add_child(b)

func lancer() -> void:
	var gains := lire_gains()
	if gains.is_empty():
		$HBoxContainer/Sortie.append_text("La matrice contient une valeur qui n'est pas un entier.\n")
		return
	tournois.Gains = gains

	tournois.nb_tours = int($"HBoxContainer/Paramètres/Tours/SpinTours".value)
	tournois.random_seed = int($"HBoxContainer/Paramètres/Seed/SpinSeed".value)
	$HBoxContainer/Sortie.clear()
	$HBoxContainer/Sortie.scroll_following = true
	$HBoxContainer/VBoxContainer/BoutonLancer.disabled = true
	await tournois.tournois()
	$HBoxContainer/VBoxContainer/BoutonLancer.disabled = false
	
