# Tiny-blacksmith

Jeu vu du dessus  
Joueur dérrière le comptoir  
Les clients entrent et demandent un item (en fonction de ce que le joueur peut crafter en fonction de son niveau)  
Le joueur doit donc récupérer les resources dans différentes caisses et crafter l'item  
Forger l'outil avec les différentes resources (mini-jeu de craft ?)  
Faire quelque chose avec le prix de l'item ?

C'est minecraft inversé, vous êtes la table de craft, les joueurs viennent vous demander les resources et le craft.

## Game Menu

![Game Menu](Assets/tiny-blacksmith-game-menu-art.png)

## Development

Todo

- [x] fix l'inventaire avec des 0
- [x] ajouter les spawns de client
- [x] ajouter plus de positions de comptoirs
- [x] ajouter un effet quand on récupère un item
- [x] récupérer les items tant qu'on est dans la zone de récupération de l'item
- [x] masquer le libellé de timer quand merci affiché sur le customer
- [x] créer la forge avec label d'interaction
- [ ] système de missions / objectifs (servir 2 clients / créer 2 fois la recette X)
- [ ] système de commandes avec livraisons par livreurs
- [ ] nouvel écran de jeu: gestion de l'inventaire, rangement des resources
- [X] faire en sorte d'afficher les recettes sur la liste
- [X] voir si possible de faire coffre de stockage d'items en avances
- [ ] faire en sorte que les clients demandes des recettes plutot que des resources (les deux ?)
- [x] écran de menu du jeu
- [X] ne pas pouvoir passer à travers la forge en orange (problème de layer et de mask)
- [X] corriger problème de fullscreen dont comptoir pas fullscreen
- [x] Bug quand je suis dans l'écran de forge je ne peux pas saisir quoi que ce soit, ni scroll (le bug vient du fait que le HUD était de type CanvasLayer, mais un seul ne peut exister, il prend la main sur le second)
- [x] Système d'argent ajouté et affiché
- [X] Quand je joue, je gagne de l'argent mais quand je clique sur le menu je perds mon argent alors que mon inventaire est gardé... (juste oubli d'affichage de l'argent)  
- [X] animation du coffre ouvrant + fermant
