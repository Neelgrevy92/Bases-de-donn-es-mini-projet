-- ----------------------------------------------------------------------------
-- BLOC 1 : PROJECTIONS ET SÉLECTIONS (Filtres de base pour l'audit)
-- Objectif : Cibler les zones et stations à inspecter.
-- ----------------------------------------------------------------------------

-- Requête 1 : (Utilisation de LIKE et ORDER BY)
-- Recherche des gares et stations liées à des saints ou des gares, triées par ordre alphabétique.
SELECT id_station, nom_station, commune 
FROM Station 
WHERE nom_station LIKE 'Saint-%' OR nom_station LIKE 'Gare%'
ORDER BY nom_station ASC;

-- Requête 2 : (Utilisation de DISTINCT et IN)
-- Extraction de la liste unique des communes desservies par les réseaux majeurs (si on avait plusieurs villes).
-- Ici, on filtre sur les stations ouvertes qui sont accessibles PMR.
SELECT DISTINCT commune 
FROM Station 
WHERE statut_station IN ('Ouverte', 'en travaux') 
  AND accessibilite_pmr = 1;

-- Requête 3 : (Utilisation de BETWEEN)
-- Audit géographique : Trouver les stations situées dans l'hyper-centre de Paris 
-- (encadrement par des coordonnées de latitude et longitude).
SELECT nom_station, latitude, longitude 
FROM Station 
WHERE latitude BETWEEN 48.8400 AND 48.8700 
  AND longitude BETWEEN 2.3300 AND 2.3800;

-- Requête 4 : (Utilisation de masques LIKE et sélection multiple)
-- Isoler les équipements qui ont besoin d'une intervention technique urgente (panne ou maintenance).
SELECT id_equipement, id_station, statut_equipement 
FROM EQUIPEMENTS 
WHERE statut_equipement NOT LIKE 'fonctionnel' 
ORDER BY statut_equipement DESC;

-- Requête 5 : (Tri complexe et opérateurs logiques)
-- Lister les stations majeures (plus de 3 accès) qui sont 100% accessibles PMR, 
-- pour les mettre en avant dans la communication de l'appli.
SELECT nom_station, nb_acces, commune 
FROM Station 
WHERE nb_acces >= 3 AND accessibilite_pmr = 1
ORDER BY nb_acces DESC, nom_station ASC;


-- ----------------------------------------------------------------------------
-- BLOC 2 : FONCTIONS D'AGRÉGATION (Statistiques et Alertes de l'App)
-- ----------------------------------------------------------------------------

-- Requête 6 : (COUNT et GROUP BY)
-- Compter le nombre de quais disponibles par station pour afficher un indicateur de taille de la gare.
SELECT id_station, COUNT(id_quai) AS nombre_de_quais
FROM Quai
GROUP BY id_station;

-- Requête 7 : (MIN, MAX sans GROUP BY)
-- Obtenir la "Bounding Box" (zone géographique maximale) du réseau pour centrer la carte au lancement de l'app.
SELECT MIN(latitude) AS sud_max, MAX(latitude) AS nord_max, 
       MIN(longitude) AS ouest_max, MAX(longitude) AS est_max
FROM Station;

-- Requête 8 : (SUM/COUNT avec condition, GROUP BY)
-- Compter le nombre de stations accessibles PMR par commune, pour une fonctionnalité "Classement des villes accessibles".
SELECT commune, COUNT(id_station) AS nb_stations_accessibles
FROM Station
WHERE accessibilite_pmr = 1
GROUP BY commune;

-- Requête 9 : (AVG et GROUP BY)
-- Calculer le temps d'attente moyen (fréquence) par station et par type de jour.
SELECT id_station, type_jour, AVG(frequence_moyenne) AS attente_moyenne_minutes
FROM HORAIRE
GROUP BY id_station, type_jour;

-- Requête 10 : (GROUP BY et HAVING)
-- Identifier les stations "critiques" qui ont au moins 2 équipements en panne (Alerte forte dans l'app).
SELECT id_station, COUNT(id_equipement) AS nb_pannes
FROM EQUIPEMENTS
WHERE statut_equipement = 'en panne' OR statut_equipement = 'en maintenance'
GROUP BY id_station
HAVING COUNT(id_equipement) >= 2;


-- ----------------------------------------------------------------------------
-- BLOC 3 : JOINTURES (Croisement des données pour l'interface utilisateur)
-- ----------------------------------------------------------------------------

-- Requête 11 : (Jointure Interne simple)
-- Afficher le nom de la ligne avec son réseau (ex: "Ligne 14 (Métro)"), pour le menu de l'appli.
SELECT L.nom_ligne, L.couleur_ligne, R.nom_reseau
FROM Ligne L
JOIN Reseau R ON L.id_reseau = R.id_reseau;

-- Requête 12 : (Jointure Multiple - 3 tables)
-- Le cœur de l'appli : Afficher les prochains passages d'une station précise (ex: Olympiades, id=8).
SELECT S.nom_station, Q.sens_circulation, H.heure_passage, H.frequence_moyenne
FROM Station S
JOIN Quai Q ON S.id_station = Q.id_station
JOIN HORAIRE H ON Q.id_station = H.id_station AND Q.id_quai = H.id_quai
WHERE S.id_station = 8 AND H.type_jour = 'Semaine'
ORDER BY H.heure_passage ASC;

-- Requête 13 : (Jointure Externe - LEFT JOIN)
-- Lister toutes les stations et leurs équipements, MÊME CELLES qui n'ont AUCUN équipement.
-- Permet d'afficher "Aucune info équipement" plutôt qu'une erreur dans l'appli.
SELECT S.nom_station, E.type_equipement, E.statut_equipement
FROM Station S
LEFT JOIN EQUIPEMENTS E ON S.id_station = E.id_station;

-- Requête 14 : (Auto-Jointure via table de liaison - TRÈS IMPORTANT)
-- Fonction "Prochain arrêt" : Afficher le nom de la station actuelle ET le nom de la station suivante.
SELECT S1.nom_station AS Station_Actuelle, S2.nom_station AS Prochain_Arret, Suivre.ordre_station
FROM Suivre
JOIN Station S1 ON Suivre.id_station = S1.id_station
JOIN Station S2 ON Suivre.id_station_1 = S2.id_station
ORDER BY Suivre.ordre_station ASC;

-- Requête 15 : (Jointure avec condition de filtrage)
-- Trouver le nom de la station qui sert de terminus à la Ligne 14.
SELECT L.nom_ligne, S.nom_station AS Station_Terminus
FROM Ligne L
JOIN TERMINUS T ON L.id_terminus = T.id_terminus
JOIN Station S ON T.id_station = S.id_station
WHERE L.code_ligne = '14';