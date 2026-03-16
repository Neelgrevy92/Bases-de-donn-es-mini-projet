# Mini-Projet : Conception et développement d'une base de données - Partie 1

## Introduction
Ce projet s'inscrit dans le cadre du module T1404 - Bases de données 1. Nous avons choisi de modéliser le système d'information de la **RATP**, spécifiquement la gestion du réseau, des stations et des horaires théoriques. Ce choix est en cohérence avec notre projet semestriel de développement d'une application de transport en commun.

## Étape 1 : Analyse des besoins

### 1.1 Méthodologie (Framework RICARDO)
Conformément aux consignes, nous avons utilisé l'Intelligence Artificielle Générative en appliquant le framework RICARDO pour définir notre périmètre métier.

**Prompt utilisé :**
> Rôle : Expert en gestion de bases de données à la RATP.
> Contexte & Références : Gestion des lignes (métro/RER), stations, accessibilité, points d'arrêt (quais), horaires théoriques et terminus. Référence : Portail Open Data RATP.
> Instructions : Agir comme le client exprimant ses besoins à un étudiant. Établir les règles de gestion en langage naturel et produire un dictionnaire de données brutes.
> Contraintes : 25 à 35 données, inclusion d'éléments pour modélisation avancée (association récursive, entité faible).
> Objectif : Fournir une base pour un MCD respectant la 3FN.

### 1.2 Règles de gestion
Les besoins collectés ont été structurés selon les axes suivants :

**Réseau et Lignes :**
* Une ligne appartient à un seul réseau (Métro, RER).
* Un réseau regroupe plusieurs lignes.
* Chaque ligne possède un identifiant interne, un numéro public (ex: 1, A), un nom commercial et une couleur officielle.
* Une ligne a un statut d'exploitation (en service, travaux, etc.).

**Stations et Accessibilité :**
* Une station possède un identifiant, un nom officiel, des coordonnées géographiques (latitude/longitude) et appartient à une commune.
* Une station peut être desservie par plusieurs lignes et peut disposer de correspondances piétonnes.
* L'accessibilité est définie par la présence d'équipements (ascenseurs, escalators) et leur statut de fonctionnement.

**Structure du réseau et Quais :**
* L'ordre des stations est défini par ligne et par sens de circulation.
* Une station possède une station suivante sur une ligne donnée (relation récursive).
* Un quai est une entité dépendante d'une station et est associé à une seule ligne et un sens de circulation.

**Horaires :**
* Les horaires sont théoriques et dépendent du type de jour (Semaine, Samedi, Dimanche, Férié).
* Ils sont définis pour un quai précis à une heure de passage donnée.

### 1.3 Dictionnaire de données
Le tableau suivant recense les 30 données identifiées lors de l'analyse :

| Donnée | Signification | Type | Taille |
| :--- | :--- | :--- | :--- |
| id_reseau | Identifiant unique du réseau | INT | 4 |
| nom_reseau | Nom du réseau (Métro, RER, etc.) | VARCHAR | 50 |
| id_ligne | Identifiant technique de la ligne | INT | 4 |
| code_ligne | Indice public de la ligne (ex: 14) | VARCHAR | 5 |
| nom_ligne | Nom commercial de la ligne | VARCHAR | 100 |
| couleur_ligne | Code couleur hexadécimal | CHAR | 7 |
| statut_ligne | État d'exploitation de la ligne | VARCHAR | 20 |
| id_station | Identifiant unique de la station | INT | 4 |
| nom_station | Nom officiel de la station | VARCHAR | 100 |
| latitude | Coordonnées : Latitude | DECIMAL | 9,6 |
| longitude | Coordonnées : Longitude | DECIMAL | 9,6 |
| commune | Ville d'implantation | VARCHAR | 100 |
| statut_station | État (Ouverte/Fermée) | VARCHAR | 20 |
| accessibilite_pmr | Indicateur d'accessibilité générale | BOOLEAN | 1 |
| nb_acces | Nombre d'entrées disponibles | INT | 2 |
| id_quai | Identifiant du quai | INT | 4 |
| sens_circulation | Direction (Aller/Retour) | VARCHAR | 10 |
| direction_terminus | Nom du terminus de direction | VARCHAR | 100 |
| id_terminus | Identifiant du terminus | INT | 4 |
| type_jour | Catégorie de jour (Semaine/Week-end) | VARCHAR | 15 |
| heure_passage | Heure théorique de passage | TIME | - |
| frequence_moyenne | Intervalle entre deux trains (min) | INT | 3 |
| premier_depart | Heure du premier service | TIME | - |
| dernier_depart | Heure du dernier service | TIME | - |
| presence_ascenseur | Indicateur présence ascenseur | BOOLEAN | 1 |
| presence_escalator | Indicateur présence escalator | BOOLEAN | 1 |
| presence_bande_podo | Indicateur dalles podotactiles | BOOLEAN | 1 |
| statut_equipement | État des équipements (OK/Panne) | VARCHAR | 20 |
| ordre_station | Position de la station sur le trajet | INT | 3 |
| id_station_suivante | Référence à la station suivante | INT | 4 |

---

## Étape 2 : Modèle Conceptuel de Données (MCD)

![MCD](https://raw.githubusercontent.com/Neelgrevy92/Bases-de-donn-es-mini-projet/main/looping.png)

### Justification de la modélisation
* **Normalisation :** Le dictionnaire évite les redondances pour respecter la 3FN.
* **Relation Récursive :** Mise en place via le lien entre une station et sa "station suivante" pour modéliser le parcours d'une ligne.

## Étape 3 : Modèle Logique de Données (MLD)

Voici la traduction de notre Modèle Conceptuel en Modèle Logique de Données relationnel :

```text
Station = (id_station INT, nom_station VARCHAR(50), latitude DECIMAL(9,6), longitude DECIMAL(9,6), commune VARCHAR(50), statut_station VARCHAR(50), accessibilite_pmr INT, nb_acces INT);
Quai = (#id_station, id_quai INT, sens_circulation VARCHAR(50));
HORAIRE = (id_jour INT, type_jour VARCHAR(50), heure_passage DATETIME, frequence_moyenne INT, premier_depart TIME, dernier_depart TIME, #(#id_station, id_quai));
TERMINUS = (id_terminus INT, #id_station);
EQUIPEMENTS = (id_equipement VARCHAR(50), presence_escalator LOGICAL, presence_bande_podo LOGICAL, statut_equipement VARCHAR(50), presence_ascenseur LOGICAL, #id_station);
Ligne = (id_ligne INT, code_ligne INT, nom_ligne VARCHAR(50), couleur_ligne VARCHAR(50), statut_ligne VARCHAR(50), #id_terminus, #id_reseau);
Suivre = (#id_station, #id_station_1, ordre_station VARCHAR(50));
```

## Etape 4 insertion de donnée 

Voici le prompt utilisé pour notre insertion de donnée
```text
:Rôle : Tu es un expert en bases de données SQL et Analyste Data à la RATP.Contexte : Je travaille sur un projet universitaire de base de données (système Merise). J'ai déjà créé mes tables. Je dois maintenant les remplir avec un nombre conséquent de données cohérentes.Instructions : Génère un script SQL d'insertion (INSERT INTO) pour les tables suivantes en respectant l'ordre des contraintes d'intégrité :Reseau : 3 enregistrements (Métro, RER, Tramway).Station : 15 stations réelles de Paris (ex: Châtelet, Bastille, Nation...).Ligne : 5 lignes (ex: Ligne 1, 4, 14, RER A, RER B) en les liant aux réseaux et aux terminus.Quai : Au moins 2 quais par station (Sens Aller/Retour).Suivre : Important ! Crée une séquence logique pour la Ligne 14 (Olympiades -> Bibliothèque -> ... -> Saint-Ouen) pour valider la relation récursive.HORAIRE : 30 horaires de passage fictifs mais réalistes.EQUIPEMENTS : Statuts variés pour les escalators et ascenseurs des stations créées.Contraintes techniques :Utilise uniquement des INSERT INTO.Respecte les types de données : TINYINT(1) pour les booléens, DECIMAL pour les coordonnées, TIME pour les heures.Assure-toi que les IDs utilisés comme clés étrangères existent bien dans les tables parentes.Format de sortie : Un bloc de code SQL prêt à l'emploi.
```
Cela nous a permis d'obtenir le fichier insertion.sql

## Étape 5 : Interrogation de la BD

Ce projet utilise SQL pour simuler le back-end d'une application de transport. Les requêtes sont organisées par complexité croissante.

---

### Bloc 1 : Projections et Sélections — *Filtres de base*

> **Objectif :** Filtrer les données brutes pour les besoins d'affichage et d'audit.

| # | Clause(s) utilisée(s) | Description | Cas d'usage applicatif |
|---|---|---|---|
| R1 | `LIKE`, `ORDER BY` | Recherche les stations dont le nom commence par `"Saint-"` ou `"Gare"` | Alimenter une **barre de recherche prédictive** |
| R2 | `DISTINCT`, `IN` | Liste les communes uniques avec stations ouvertes et accessibles PMR | Afficher une **liste de filtres par ville** dans les paramètres d'accessibilité |
| R3 | `BETWEEN` | Cible les stations dans une zone géographique précise (Paris centre) | Affichage des stations sur la carte lors d'un **zoom sur l'hyper-centre** |
| R4 | `NOT LIKE` | Isole les équipements non fonctionnels | Tableau de bord pour **techniciens de maintenance** |
| R5 | Opérateurs logiques | Stations à fort flux (`nb_acces >= 3`) et 100% accessibles | Promotion des **stations "confort"** pour voyageurs en situation de handicap |

---

### Bloc 2 : Fonctions d'Agrégation — *Statistiques et Alertes*

> **Objectif :** Calculer des indicateurs de performance et d'état du réseau.

| # | Clause(s) utilisée(s) | Description | Cas d'usage applicatif |
|---|---|---|---|
| R6 | `COUNT`, `GROUP BY` | Calcule le nombre de quais par station | Indiquer visuellement **l'importance d'une gare** sur la carte |
| R7 | `MIN`, `MAX` | Détermine les coordonnées extrêmes du réseau (N/S/E/O) | **Ajuster le zoom** de la carte pour englober tout le réseau |
| R8 | Agrégation filtrée | Compte les stations accessibles par commune | Créer un **"Palmarès de l'accessibilité"** institutionnel |
| R9 | `AVG`, `GROUP BY` | Calcule le temps d'attente moyen par station et par type de jour | Informer l'utilisateur sur la **fréquence de passage** prévue |
| R10 | `HAVING` | Identifie les stations ayant ≥ 2 équipements en panne | Système d'**alerte automatique "Incident majeur"** |

---

### Bloc 3 : Jointures — *Croisement de données*

> **Objectif :** Lier les entités entre elles pour donner du sens aux informations.

| # | Type de jointure | Description | Cas d'usage applicatif |
|---|---|---|---|
| R11 | `INNER JOIN` | Associe les lignes à leurs réseaux respectifs | Afficher `"Ligne 1 (Métro)"` ou `"Ligne A (RER)"` dans les résultats |
| R12 | Jointure triple | Récupère les horaires de passage pour une station donnée | Écran **"Prochains départs"** de l'application |
| R13 | `LEFT JOIN` | Liste toutes les stations, même sans équipements référencés | Éviter de **masquer une station** faute de données d'ascenseur |
| R14 | Auto-jointure | Relie une station à sa station suivante sur la ligne | Vue **"Trajet en cours"** : arrêt actuel → prochain arrêt |
| R15 | Jointure avec filtre | Trouve le nom du terminus d'une ligne donnée | Afficher la **direction du train** (ex: *Direction Olympiades*) |

---

### Bloc 4 : Requêtes Imbriquées — *Logique complexe*

> **Objectif :** Effectuer des sélections basées sur des résultats de sous-requêtes.

| # | Clause(s) utilisée(s) | Description | Cas d'usage applicatif |
|---|---|---|---|
| R16 | `IN` | Sélectionne les quais appartenant uniquement aux stations parisiennes | Extraction pour **audit municipal** |
| R17 | `NOT EXISTS` | Liste les stations totalement dépourvues d'équipements techniques | Identifier les **zones "grises"** du réseau |
| R18 | `ALL` | Trouve la station avec le record absolu du nombre d'accès | Statistique **"Le saviez-vous ?"** / identification des hubs majeurs |
| R19 | `ANY` | Trouve les stations situées plus au Nord que toute station de Saint-Ouen | **Analyse géographique** pour extension des zones tarifaires |
| R20 | `EXISTS`, `JOIN` | Liste les lignes dont au moins un terminus est accessible PMR | Filtre de recherche **"Itinéraire 100% accessible"** |



**Entité Faible :** Le Quai est modélisé comme une entité faible dépendant de la Station

