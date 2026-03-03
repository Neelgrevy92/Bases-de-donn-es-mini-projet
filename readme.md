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

https://github.com/Neelgrevy92/Bases-de-donn-es-mini-projet/looping.png
[Image de l'arborescence du projet avec le fichier source du MCD]

### Justification de la modélisation
* [cite_start]**Normalisation :** Le dictionnaire évite les redondances pour respecter la 3FN[cite: 82].
* [cite_start]**Relation Récursive :** Mise en place via le lien entre une station et sa "station suivante" pour modéliser le parcours d'une ligne[cite: 85].

* [cite_start]**Entité Faible :** Le Quai est modélisé comme une entité faible dépendant de la Station[cite: 87].
