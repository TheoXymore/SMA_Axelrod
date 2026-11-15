# SMA_Axelrod
**Théo HOURMAND**

Implémentation du tournois de dilemmes du prisonier

Ce projet est réalisé avec le moteur de jeu Godot, principalement car je suis à l'aise avec le GDscript

## Journal de bord

### Protocole

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

### Chaque stratégie
 - ALL-D : Le joueur choisit tout le temps de Déférer. Devrait gagner tous ses matchs, mais pas forcément générer le plus de points
 - RANDOM : Le joueur choisit aléatoirement de Coopérer ou de Déférer. 
 - TIT-FOR-TAT : Le joueur Coopère au premier tour puis répond ce qu'a joué son adversaire. Permet de ne pas perdre trop contre ALL-D et de génrérer beaucoup de points avec des stratégies altruistes
 - TESTER : Le joueur Défère au premier tour puis s'excuse en Coopérant. Si l'adversaire lui répond par la Défection, il passe en stratégie TfT, sinon il fait C,C,D en boucle. Comme pour TfT, réduit le gain de ALL-D, mais n'a pas l'avantage de bien s'en sortir face à TfT
 - JOSS : TfT mais une chance sur 10 de Déférer au lieu de Coopérer. Pourrait ruiner l'efficacité de TfT
 - PIGEON : L'archnémésis de All-D : celui ci Coopère tout le temps (On profite souvent de lui). Il s'en sort bien face à des stratégies altruistes mais très mal face à des stratégies égoistes
 - INDECIS : Un tour sur deux, il Coopère, un tour sur deux, il Défère. Un peut comme la stratégie random, il ne devrait ni bien s'en sortir face à des stratégies egoistes, ni rentabiliser les rencontres avec des stratégies altruistes.

### Etape 3

L'étape 3 consiste à ajouter deux modifications au tournois. Celles que j'ai apportées sont :
	 - Bruit : Chaque coup est inversé avec un petite probabilité (5%).
	 	- J'ai implémenté cette modification car c'est selon moi celle qui s'insérait le mieux dans la structure de mon projet (avant d'utiliser le résultat de la méthode jouer(), je le fais passer dans une méthode bruit()).
	 	- Cela permettrait aussi de créer des retournements de situation (la stratégie Tester deviendrait alors beaucoup moins efficace face à elle même), et permettrait à plusieurs stratégies identiques dans le tournois d'avoir des résultats légèrement différents, pour simuler des vrais joueurs qui, bien que suivant la même stratégie, pourraient parfois faire des choix irrationnels.
		- Après avoir lancé deux tournois : les 7 stratégies, 200 tours, matrice de gain normale, seed = 200 je constate que :
			- l'ajout du bruit a permis à des stratégies comme Tester de gagner près de 1000 points, se hissant à la deuxième position. En effet, j'imagine que cela a permis parfois de gagner plus de points face à des algorithmes non rancuniers, et de ne pas se retrouver en situation d'alternance face à des algorithmes rancuniers (comme TfT ou Joss)
			- En revanche, et assez logiquement, la stratégie Pigeon ou Random n'ont pas su tirer profit de ce changement et ont perdu près de 1000 points au total. Le bruit ne change pas vraiment la façon de faire de la stratégie Random, et la stratégie Pigeon est celle qui s'est faite le plus exploiter
	- Autres gains : la matrice change : soit elle reste un dilemme, soit elle devient un autre jeu 2x2 de la section 07 du cours
		- J'ai implémenté cette modification car c'est selon moi la plus intéressant et elle permettrait de simuler de noumbreuses situations différentes, et j'avais vraiment envie de voir quelles issues serait créées lorsque les gains sont différents.
		- Je pense aussi que, si il fallait implémenter un système multi-agent dans le même style que l'agent de réconfort, il ne faudrait pas que, dans le cas du goulot d'étranglement, les deux agents soient tentés de faire le même choix. La matrice de gain doit alors permettre aux agents de gagner plus de points si ils ne font pas le même choix (C,D ou D,C)
		- J'ai donc pu tester différentes matrices du cours, et enregistrer leurs résultats dans des captures d'écran
			- Chasse au cerf : TIT-FOR-TAT est toujours la stratégie dominannte, mais, assez logiquement, ALL-D et Pigeon ont été inversé ! ALL-D a eu ce qu'il méritait ! C'est normal puisque dans cette configuration, déférer trop souvent apporte bien moins de points que de coopérer trop souvent.
			- Poule mouillée : C'est une stratégie qui pourrait bien simuler le cas du couloir étroit : (D,D) donne le pire score (on se percute), tandis que (C,C) donne un bon score (on ne veut surtout pas aller jusqu'à la collision), mais (C,D) et (D,C) rapportent beaucoup de points à celui qui passe, puisque cela débloque la situation. Les stratégies qui se copient devraient alors gagner moins de points, tandis qu'une stratégie qui casse les habitudes permet de générer plus de points (Random, Indécis,...)
