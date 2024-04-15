# Tableau de bord interactif - Powerlifting Dashboard

### Fichiers du Projet ("User Guide")

## Packages Nécessaires
**Assurez-vous d'installer les packages suivants avant d'exécuter le fichier `main.R` :**
- `shiny`
- `shinydashboard`
- `ggplot2`
- `dplyr`
- `lubridate`
- `leaflet`
- `leaflet.extras`
- `plotly`
- `DT`

## Fichier à Charger
Le fichier `main.R` contient le code principal de l'application Shiny. Assurez-vous d'avoir chargé les données nécessaires avant d'exécuter ce fichier. Les fichiers de données doivent être nommés `power.csv` pour les données du powerlifting et `capitale.csv` pour les données sur les capitales du monde.

## Liens de Téléchargement des Données
- [Téléchargez le fichier de données sur les capitales du monde] (https://opendata.koumoul.com/datasets/capitales-du-monde)
- [Téléchargez le fichier de données sur le powerlifting] (https://www.kaggle.com/datasets/docgenki/powerlifting-dataset)

---

**Note :** Assurez-vous d'avoir correctement configuré les liens de téléchargement des données dans le fichier `variables.R` avant d'exécuter le code.

---


## Introduction :
Ce tableau de bord interactif a été créé pour analyser les données du powerlifting. Il offre des visualisations et des analyses détaillées sur les performances des athlètes, les compétitions et les tendances du powerlifting. 
Le dataset de powerlifting est composé de 2,9 millions de lignes et 41 colonnes. Le dataset des capitales est lui, composé de 245 lignes et de 6 colonnes. 
En raison de ce grand nombre de données, le dashboard met quelques secondes à se lancer et à se mettre à jour lors des interactions. Merci, de bien vouloir attendre quelques secondes.

**informatif :**: Nous aurions aimé aller directement chercher les informations sur kaggle (en dynamique) cependant le dataset était très volumineux donc prenait du temps à être téléchargé. On a donc dû abandonner cette idée. De plus, le dataset de la position géographique des capitales n'a pas grand intérêt à être récupéré dynamiquement car ce sont des infromations qui ne sont pas amenées à évoluer dans le temps.


**Aides :** 
- https://rstudio.github.io/shinydashboard/
- https://lrouviere.github.io/TUTO_R/leaflet.html
- https://rstudio.github.io/leaflet/markers.html
- https://stt4230.rbind.io/programmation/fonctions_r/
- https://www.valdemarne.fr/newsletters/sport-sante-et-preparation-physique/lhomme-est-il-reellement-plus-fort-que-la-femme-dans-le-monde-de-la-performance-sportive

Voici un aperçu de ce que vous pouvez explorer avec ce tableau de bord :

## Graphiques Disponibles ("Developpement Guide")

1. **Onglet Accueil :**
   - **Nombre de Participants :** Un compteur indiquant le nombre total de participants dans le jeu de données.
   - **Le Plus Gros Total :** Affiche le nom de l'athlète avec le plus gros total en kilogrammes.
   - **Meilleur(e) Athlète Goodlift Points :** Montre le nom de l'athlète avec le plus grand nombre de points Goodlift, ainsi que son poids et total en kilogrammes soulevés/poussés.
   - **Total en Kg pour les Athlètes Français à l'International :** Un graphique montrant l'évolution du total en kilogrammes pour les athlètes français participant à des compétitions internationales.
   - **Vue d'Ensemble des Participants au Championnat de Sheffield :** Un tableau montrant les détails des participants au Championnat de Sheffield.
   - **Carte des Participants :** Une carte interactive affichant les capitales du monde avec des marqueurs colorés indiquant le nombre de participants venant de chacun des pays.

2. **Onglet Athlètes :**
   - **Répartition des Athlètes Selon l'Âge :** Un histogramme montrant la répartition des athlètes selon leur âge.
   - **Répartition des Athlètes Selon le Genre :** Un graphique circulaire indiquant la répartition des athlètes par genre.
   - **Filtrage par Genre :** Vous pouvez choisir de filtrer les données par genre.
   - **Répartition des Athlètes Selon les Catégories de Poids :** Un graphique à barres montrant la répartition des athlètes selon les catégories de poids.

3. **Onglet Records :**
   - **Meilleure Performance par Catégorie de Poids :** Un graphique à barres interactif permettant de comparer les meilleures performances des athlètes dans différentes catégories de poids, en fonction du mouvement sélectionné (Deadlift, Bench, Squat ou Total).

4. **Onglet À Propos :**
   - **À Propos du Powerlifting :** Un texte informatif expliquant le déroulement d'une compétition de powerlifting et l'essence de ce sport.
   - **Information sur le Jeu de Données :** Un texte décrivant les aspects du jeu de données utilisé, y compris les détails démographiques, les performances et les compétitions.



N'hésitez pas à explorer les différentes fonctionnalités de ce tableau de bord interactif et à découvrir les insights fascinants sur le monde du powerlifting !

Ce projet a été créé par [Amaury BODIN et Vincent BERNARD].

Bonne exploration !

### Analyse :

**Accueil :** 
- Sur cette page nous pouvons voir plusieurs choses. Dans un 1er temps différentes statistiques qui indiquent respectivement, le nombre de participants différents présents dans le dataset. La personne ayant fait le plus gros total sur 3 mouvement (Squat, Bench, Deadlift), ainsi que l'athlète ayant le meilleur googliftpoint (nombre de points attribués en fonction du poids, la taille, le genre, ...). Avec quelques unes de ces stastistiques on peut voir que c'est pas un sport qui est très pratiqué comme peuvent l'être le foot ou le tennis mais il y a quand même un certain nombre de pratiquants. On peut aussi voir que le corps humain est de manière générale plus fort et plus solide qu'on le pense en général. 
- On retouve en dessous, un graph qui indique la meilleure performance de chacun des francais par année. On peut voir qu'au fur et à mesure des années il y a de plus en plus de français qui se mettent au powerlifting. On peut égalment voir l'impacte du covid sur le nombre de français ayant participé à une compétition. On peut égalment voir qu'il y a un rapport entre le poids d'un individus et la charge qu'il est capable de soulever. Plus un individus est lourd plus il est capable de souler lourd.
- A droite, on peut voir quelques caractéristiques des participants à la compétition de Sheffiled qui est la plus grande compétition de Powerlifting. On peut voir que c'est lors de cette compétition que le plus gros total jamais réalisé à été effectué parJesus Olivarez, 1152.5 Kg. On peut égalment voir que de manière générale le total d'un Homme est becoup plus élévé que celui des femmes. Selon les chercheurs Koulmann & Malgyore, "ils constatent que les femmes peuvent avoir un déficit de force ou de puissance de 40 à 60% pour les membres supérieurs et de 25 à 30% pour les membres inférieurs". Ceci s'explique par la production de testostérone faite par l'homme qui permet de développer massivement ses muscles. En effet, l'homme adulte possède un taux de testostérone de 6 microgrammes/litres contrairement à 0.3 pour les femmes.  
- Puis pour finir, on possède une carte sur laquelle il y a des Pointeurs de différentes couleurs qui correspondent au nombre de participants différents de chacun des pays. On peut voir que c'est un sport qui est très pratiqué en Amérique du Nord et qui prend petit à petit en Europe. De plus en plus de sportifs s'y mettent même si ce sport reste très peu pratiqué en Asie et en Afrique. En effet, c'est un sport qui peut coûter cher car il nécessite par mal de matériel.

**Athlètes :**
- Ici, on peut voir un histogram qui montre la répartition de l'age des différents participants. On peut voir que la majorité desparticipants ont entre 18 et 25 ans. C'est un sport qui se développe de plus en plus chez les jeunes. C'est un sport qui est voué à beaucoup se développer les prochaines années car la majorité des participants sont des jeunes adultes. 
- Sur le diagrame circulaire situé à côté, on peut voir que c'est un sport qui est compposé de ~75 % d'hommes. 
Pour finir, on peut voir que chez les hommes la majorité des participants font font entre 75 et 105 Kg alors que chez les femmes cette répartition de poids est beaucoup plus uniforme sur leurs catégories de poids. 
 
**Records :**
- On peut sélectionner différents paramètres, on peut observer la corrélation entre le poids d'un athlète sur ce qu'il peut tirer sur chacun des mouvements. On peut voir de manière générale que plus les participants sont lourds plus il peuvent souler lourd. Si on fait bouger le slider, pour parcourir les années. On peut voir que la meilleure performance par année de chacune des catégories à énormément évolué avec une proféssionalisation du sport. Par exemple, en l'an 2000 la meilleure performance de l'année avait été realisé par un homme de la catégorie des -120Kg, il avait soulevé près de 830Kg. Cette année, la meilleure perfomance à été réalisée par un homme de la catégorie des +120Kg, il a soulevé au total plus de 1100Kg. Ce qui désigne une énorme progression dans ce sport en l'espace de 20 ans. Les records du monde de chacune des catégories sont battus quasiment chaque années.

**A propos :** 
Dans le bar graph, on peut confimer la tendance qu'on vait perçu sur la carte précédente. En effet, nous pouvons constater que près de 70% des partcipants font partie des 9 pays montrés dessus. Dont 6 sont en Europe et 2 en Amerique du Nord. 
On peut également constater à droite d'une large augmentation du nombre de compétition de powerlifting dans le monde. Un sport en explosion, on peut voir l'impact qu'a eu le covid sur la pratique du sport, le powerlifting. En 2023, l'année n'est pas finie et de grandes échéances approchent avec l'arrivée des championats d'Europe. 

### Conclusion :

Comme vous avez pu le constater, le powerlifting est un sport en constante expansion d'année en année. De plus en plus de personnes, qu'elles soient compétitrices ou simplement passionnées, s'y adonnent. Les performances et les records du monde sont régulièrement battus, témoignant de la détermination et du dépassement de soi des athlètes. Ce sport met en lumière des capacités physiques humaines parfois insoupçonnées. L'exploration de ces données révèle non seulement les aspects compétitifs du powerlifting, mais aussi la force et la diversité des individus qui le pratiquent.