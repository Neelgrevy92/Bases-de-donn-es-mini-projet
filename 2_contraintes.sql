-- =============================================================================
-- FICHIER : 2_contraintes.sql
-- DESCRIPTION : Ajout des contraintes de validation (CHECK) basées sur les 
--               règles métier RATP (Étape 3.B du projet).
-- =============================================================================

-- 1. Validation des coordonnées géographiques (Latitude entre -90 et 90, Longitude entre -180 et 180)
ALTER TABLE Station 
ADD CONSTRAINT chk_coords_lat CHECK (latitude BETWEEN -90 AND 90);

ALTER TABLE Station 
ADD CONSTRAINT chk_coords_long CHECK (longitude BETWEEN -180 AND 180);

-- 2. Validation du nombre d'accès (doit être positif)
ALTER TABLE Station 
ADD CONSTRAINT chk_nb_acces CHECK (nb_acces >= 0);

-- 3. Contrainte sur le statut de la ligne (Règle métier : en service, suspendue, en travaux)
ALTER TABLE Ligne 
ADD CONSTRAINT chk_statut_ligne 
CHECK (statut_ligne IN ('en service', 'suspendue', 'en travaux'));

-- 4. Contrainte sur la couleur (doit commencer par '#' pour un code hexadécimal)
ALTER TABLE Ligne 
ADD CONSTRAINT chk_couleur_hex CHECK (couleur_ligne LIKE '#%');

-- 5. Validation du sens de circulation (Règle métier : Aller ou Retour)
ALTER TABLE Quai 
ADD CONSTRAINT chk_sens_circulation 
CHECK (sens_circulation IN ('Aller', 'Retour'));

-- 6. Fréquence moyenne (ne peut pas être une valeur négative ou nulle)
ALTER TABLE HORAIRE 
ADD CONSTRAINT chk_frequence CHECK (frequence_moyenne > 0);

-- 7. Type de jour (Règle métier : Semaine, Samedi, Dimanche, Férié)
ALTER TABLE HORAIRE 
ADD CONSTRAINT chk_type_jour 
CHECK (type_jour IN ('Semaine', 'Samedi', 'Dimanche', 'Férié'));

-- 8. Statut des équipements (Règle métier : fonctionnel, en panne, en maintenance)
ALTER TABLE EQUIPEMENTS 
ADD CONSTRAINT chk_statut_equipement 
CHECK (statut_equipement IN ('fonctionnel', 'en panne', 'en maintenance'));

-- 9. Cohérence des horaires (Le premier départ doit être avant le dernier départ)
ALTER TABLE HORAIRE 
ADD CONSTRAINT chk_horaires_coherence CHECK (premier_depart < dernier_depart);