-- Fichier : 1_creation.sql
-- Description : Création des tables avec gestion des contraintes d'intégrité référentielle

CREATE TABLE Reseau(
   id_reseau INT,
   nom_reseau VARCHAR(50),
   PRIMARY KEY(id_reseau)
);

CREATE TABLE Station(
   id_station INT,
   nom_station VARCHAR(50),
   latitude DECIMAL(9,6),
   longitude DECIMAL(9,6),
   commune VARCHAR(50),
   statut_station VARCHAR(50),
   accessibilite_pmr TINYINT(1), -- Remplacé LOGICAL par TINYINT pour la compatibilité
   nb_acces INT,
   PRIMARY KEY(id_station)
);

CREATE TABLE Quai(
   id_station INT,
   id_quai INT,
   sens_circulation VARCHAR(50),
   PRIMARY KEY(id_station, id_quai),
   FOREIGN KEY(id_station) REFERENCES Station(id_station) 
      ON DELETE CASCADE ON UPDATE CASCADE -- Gestion automatique demandée 
);

CREATE TABLE HORAIRE(
   id_station INT,
   id_quai INT,
   id_horaire INT,
   type_jour VARCHAR(50),
   heure_passage DATETIME,
   frequence_moyenne INT,
   premier_depart TIME,
   dernier_depart TIME,
   PRIMARY KEY(id_station, id_quai, id_horaire),
   FOREIGN KEY(id_station, id_quai) REFERENCES Quai(id_station, id_quai) 
      ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE TERMINUS(
   id_terminus INT,
   id_station INT NOT NULL,
   PRIMARY KEY(id_terminus),
   FOREIGN KEY(id_station) REFERENCES Station(id_station) 
      ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE EQUIPEMENTS(
   id_station INT,
   id_equipement INT,
   presence_escalator TINYINT(1),
   presence_bande_podo TINYINT(1),
   statut_equipement VARCHAR(50),
   presence_ascenseur TINYINT(1),
   PRIMARY KEY(id_station, id_equipement),
   FOREIGN KEY(id_station) REFERENCES Station(id_station) 
      ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Ligne(
   id_ligne INT,
   code_ligne VARCHAR(10), -- Changé en VARCHAR car certaines lignes sont des lettres (ex: A, B)
   nom_ligne VARCHAR(50),
   couleur_ligne VARCHAR(50),
   statut_ligne VARCHAR(50),
   id_terminus INT NOT NULL,
   id_reseau INT NOT NULL,
   PRIMARY KEY(id_ligne),
   FOREIGN KEY(id_terminus) REFERENCES TERMINUS(id_terminus) ON DELETE CASCADE,
   FOREIGN KEY(id_reseau) REFERENCES Reseau(id_reseau) ON DELETE CASCADE
);

CREATE TABLE Suivre(
   id_station INT,
   id_station_1 INT,
   ordre_station INT, -- Changé en INT pour permettre des tris numériques
   PRIMARY KEY(id_station, id_station_1),
   FOREIGN KEY(id_station) REFERENCES Station(id_station) ON DELETE CASCADE,
   FOREIGN KEY(id_station_1) REFERENCES Station(id_station) ON DELETE CASCADE
);