-- BDR 2018

--tme Jointure Répartie

-- exemple de fichier pour préparer le tme


-- ============================
-- SITE 1
-- ============================
connect E3502264/E3502264@ora11
SELECT sys_context('USERENV', 'INSTANCE_NAME') FROM dual; 

--créer les Clubs





-- ============================
-- SITE 2
-- ============================
connect E.../E...@ora10
SELECT sys_context('USERENV', 'INSTANCE_NAME') FROM dual; 

--créer les Stagiaires






-- ============================
-- SITE 1
-- ============================
connect E3502264/E3502264@ora11
SELECT sys_context('USERENV', 'INSTANCE_NAME') FROM dual; 

--créer le lien et la vue

CONNECT E3502264/E3502264@ora11
    @tableClub
    DESC Club


CONNECT E3502264/E3502264@ora10  
    @tableStagiaire
    DESC Stagiaire

CONNECT E3502264/E3502264@ora11
    DROP DATABASE link site2;
    -- remplacer 1234567 par votre numéro d'étudiant
    CREATE DATABASE link site2 CONNECT TO E1234567 IDENTIFIED BY "E1234567" USING 'ora10';

CONNECT E3502264/E3502264@ora11
    DESC Stagiaire@site2



CONNECT E3502264/E3502264@ora11
    CREATE VIEW Stagiaire AS
    SELECT *
    FROM Stagiaire@site2;


-- Requête R1

CONNECT E3502264/E3502264@ora11
    EXPLAIN plan FOR
    SELECT s.prenom, s.profil, c.division
    FROM Stagiaire s, Club c
    WHERE s.cnum = c.cnum;
    @p5

-- Requête R2

SET linesize 120
    EXPLAIN plan FOR
    SELECT s.prenom, s.profil, c.division
    FROM Stagiaire s, Club c
    WHERE s.cnum = c.cnum
    AND s.salaire > 59000;
    @p5


-- Requête R3

-- Requête R3a

EXPLAIN plan FOR
    SELECT s.prenom, s.profil, c.division
    FROM Stagiaire s, Club c
    WHERE s.cnum = c.cnum
    AND c.ville = 'ville7';
    @p5

-- Requête R3b
 EXPLAIN plan FOR
    SELECT /*+ driving_site(s) */ s.prenom, s.profil, c.division
    FROM Stagiaire s, Club c
    WHERE s.cnum = c.cnum
    AND c.ville = 'ville7';
    @p5


--4) Durée des transferts

--a) Avec transfert de tous les stagiaires

SET timing ON
DECLARE
  res NUMBER;
BEGIN
  FOR i IN 1 .. 10 LOOP
     SELECT MAX(LENGTH(s.profil))
     INTO res
     FROM Stagiaire s, Club c
     WHERE s.cnum = c.cnum
     AND c.ville = 'ville7';
  END LOOP;
END;
/
SET timing off


--b) Avec transfert des clubs de la ville7

SET timing ON
DECLARE
res NUMBER;
BEGIN
FOR i IN 1 .. 10 LOOP
    SELECT /*+ driving_site(s) */ MAX(LENGTH(s.profil))
    INTO res
    FROM Stagiaire s, Club c
    WHERE s.cnum = c.cnum
    AND c.ville = 'ville7';
END LOOP;
END;
/
SET timing off

--5) Fragmentation

SELECT *
FROM Club c
WHERE c.division=1;
