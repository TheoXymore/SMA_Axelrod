# SMA_Axelrod
**Théo HOURMAND**

Implémentation du tournois de dilemmes du prisonier

Ce projet est réalisé avec le moteur de jeu Godot, principalement car je suis à l'aise avec le GDscript

##Journal de bord

###Protocole

Le projet est séparé en 3 couches :
	
	- Stratégie :
		- La classe stratégie représente à la fois la stratégie utilisée par le joueur et le joueur en lui même
		- Chaque instance de la classe est un joueur : son nombre de points, de tours joués, son algorithme de décision...
		- La classe Stratégie est une classe abstraite définissant la méthode abstraite jouer()->Choix
		- le type Choix est simplement un alias pour COOPERER = 0 et DEFERER = 1, ce qui permettra de choisir la ligne et la colonne de la matrice de gains
	
	- Partie :
		- La classe Partie représente... une partie. Elle est construite avec deux joueurs et un nombre de tours
		- Une partie boucle sur le nombre de tours, qui se déroulent ainsi : les joueurs font leur choix (fonction jouer()), la partie récupère les résultats dans la matrice de gain, puis donne les points correspondants aux joueurs
		- Ce n'est pas ici qu'est déterminé le vainqueur mais dans la couche supérieure : le Tournois
		
	- Tournois :
		- La classe Tournois va permettre de simuler des duels entre chaque joueur
		- Un duel est une suite de parties jusqu'à ce qu'un des joueurs atteigne 3 points (3 parties gagnées) ou que les 5 matchs ont été joué mais se soldent sur une égalité. Cela impactera le score final puisqu'un joueur profitant de son adversaire ne pourra le faire que pendant 3 parties
		- Le score final peut être déterminé de plusieurs façons : nombre de victoire, nombre de points, points moyens par partie, points moyens par tour...
		- J'ai fait le choix de les classer par points moyens par tour. J'ignore sincèrement si c'est la meilleure façon de classer mais je note aussi le nombre de victoires et cela permet de constater que parfois un joueur a une meilleur moyenne avec moins de victoires

###Chaque stratégie
 - ALL-D : Le joueur choisit tout le temps de Déférer.
 - RANDOM : Le joueur choisit aléatoirement de Coopérer ou de Déférer
 - TIT-FOR-TAT : Le joueur Coopère au premier tour puis répond ce qu'a joué son adversaire
 - TESTER : Le joueur Défère au premier tour puis s'excuse en Coopérant. Si l'adversaire lui répond par la Défection, il passe en stratégie TfT, sinon il fait C,C,D en boucle
 - JOSS : TfT mais une chance sur 10 de Déférer au lieu de Coopérer
 - PIGEON : L'archnémésis de All-D : celui ci Coopère tout le temps (On profite souvent de lui)
 - INDECIS : Un tour sur deux, il Coopère, un tour sur deux, il Défère
