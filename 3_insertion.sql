-- ============================================================
--  SCRIPT D'INSERTION RATP - CORRIGÉ POUR CORRESPONDRE AU MLD
--  Fichier : 3_insertion.sql
-- ============================================================

-- 1. RESEAU (On retire la colonne inventée 'type_reseau')
INSERT INTO Reseau (id_reseau, nom_reseau) VALUES
(1, 'Métro'),
(2, 'RER'),
(3, 'Tramway');

-- 2. STATION (On remet 'commune', 'statut_station', 'accessibilite_pmr' et 'nb_acces')
INSERT INTO Station (id_station, nom_station, latitude, longitude, commune, statut_station, accessibilite_pmr, nb_acces) VALUES
(1, 'Châtelet', 48.8600, 2.3469, 'Paris', 'Ouverte', 1, 4),
(2, 'Bastille', 48.8533, 2.3692, 'Paris', 'Ouverte', 1, 3),
(3, 'Nation', 48.8484, 2.3961, 'Paris', 'Ouverte', 1, 5),
(4, 'Gare de Lyon', 48.8448, 2.3735, 'Paris', 'Ouverte', 1, 6),
(7, 'Saint-Lazare', 48.8759, 2.3249, 'Paris', 'Ouverte', 1, 5),
(8, 'Olympiades', 48.8261, 2.3641, 'Paris', 'Ouverte', 1, 2),
(9, 'Bibliothèque François Mitterrand', 48.8299, 2.3763, 'Paris', 'Ouverte', 1, 3),
(10, 'Cour Saint-Émilion', 48.8335, 2.3845, 'Paris', 'Ouverte', 0, 1),
(11, 'Bercy', 48.8400, 2.3793, 'Paris', 'Ouverte', 1, 2),
(12, 'Gare de Bercy', 48.8403, 2.3791, 'Paris', 'Ouverte', 1, 1),
(13, 'Madeleine', 48.8699, 2.3249, 'Paris', 'Ouverte', 1, 4),
(14, 'Saint-Ouen', 48.9086, 2.3332, 'Saint-Ouen', 'Ouverte', 1, 2),
(15, 'Mairie de Saint-Ouen', 48.9124, 2.3358, 'Saint-Ouen', 'Ouverte', 1, 3);

-- 3. TERMINUS (Nécessaire avant de créer les lignes !)
INSERT INTO TERMINUS (id_terminus, id_station) VALUES
(1, 3),  -- Nation
(2, 7),  -- Saint-Lazare
(3, 8),  -- Olympiades
(4, 15), -- Mairie de Saint-Ouen
(5, 4),  -- Gare de Lyon
(6, 1);  -- Châtelet

-- 4. LIGNE (On respecte la structure : id, code, nom, couleur, statut, id_terminus, id_reseau)
INSERT INTO Ligne (id_ligne, code_ligne, nom_ligne, couleur_ligne, statut_ligne, id_terminus, id_reseau) VALUES
(1, '1', 'Ligne 1', '#FFCD00', 'en service', 1, 1),
(2, '4', 'Ligne 4', '#A0006E', 'en service', 2, 1),
(3, '14', 'Ligne 14', '#662D91', 'en service', 4, 1),
(4, 'A', 'RER A', '#E2001A', 'en service', 5, 2),
(5, 'B', 'RER B', '#4B92DB', 'en service', 6, 2);

-- 5. QUAI (id_station, id_quai, sens_circulation)
INSERT INTO Quai (id_station, id_quai, sens_circulation) VALUES
(8, 1, 'Aller'), (8, 2, 'Retour'),
(9, 3, 'Aller'), (9, 4, 'Retour'),
(10, 5, 'Aller'), (10, 6, 'Retour'),
(11, 7, 'Aller'), (11, 8, 'Retour'),
(12, 9, 'Aller'), (12, 10, 'Retour'),
(4, 11, 'Aller'), (4, 12, 'Retour'),
(1, 13, 'Aller'), (1, 14, 'Retour'),
(13, 15, 'Aller'), (13, 16, 'Retour'),
(7, 17, 'Aller'), (7, 18, 'Retour'),
(14, 19, 'Aller'), (14, 20, 'Retour'),
(15, 21, 'Aller'), (15, 22, 'Retour');

-- 6. SUIVRE (La relation récursive : id_station, id_station_1, ordre_station)
-- Parcours de la Ligne 14
INSERT INTO Suivre (id_station, id_station_1, ordre_station) VALUES
(8, 9, 1),   -- Olympiades -> BNF
(9, 10, 2),  -- BNF -> Cour St-Emilion
(10, 11, 3), -- Cour St-Emilion -> Bercy
(11, 12, 4), -- Bercy -> Gare de Bercy
(12, 4, 5),  -- Gare de Bercy -> Gare de Lyon
(4, 1, 6),   -- Gare de Lyon -> Châtelet
(1, 13, 7),  -- Châtelet -> Madeleine
(13, 7, 8),  -- Madeleine -> Saint-Lazare
(7, 14, 9),  -- Saint-Lazare -> Saint-Ouen
(14, 15, 10);-- Saint-Ouen -> Mairie de Saint-Ouen

-- 7. HORAIRE (Correction des heures de dernier départ pour satisfaire la contrainte SQL)
INSERT INTO HORAIRE (id_station, id_quai, id_horaire, type_jour, heure_passage, frequence_moyenne, premier_depart, dernier_depart) VALUES
(8, 1, 1, 'Semaine', '2026-03-13 07:00:00', 3, '05:30:00', '23:59:00'),
(8, 1, 2, 'Semaine', '2026-03-13 07:03:00', 3, '05:30:00', '23:59:00'),
(1, 13, 3, 'Samedi', '2026-03-14 12:00:00', 5, '05:30:00', '23:59:00'),
(15, 22, 4, 'Dimanche', '2026-03-15 15:00:00', 6, '05:30:00', '23:59:00'),
(4, 11, 5, 'Férié', '2026-05-01 09:00:00', 10, '05:30:00', '23:59:00');

-- 8. EQUIPEMENTS (id_station, id_equipement, presence_escalator, presence_bande_podo, statut_equipement, presence_ascenseur)
INSERT INTO EQUIPEMENTS (id_station, id_equipement, presence_escalator, presence_bande_podo, statut_equipement, presence_ascenseur) VALUES
(1, 1, 1, 1, 'fonctionnel', 1),
(1, 2, 1, 1, 'en panne', 0),
(4, 3, 1, 1, 'fonctionnel', 1),
(8, 4, 1, 1, 'en maintenance', 1),
(15, 5, 1, 1, 'fonctionnel', 1);