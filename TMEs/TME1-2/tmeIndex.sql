

-- ===================
-- 3I009 2017
-- ===================

-- Compte rendu du TME 4-5 sur les plan d'exécution
-- ================================================

-- NOM, Prénom 1 : BALDE, Ahmed Tidiane
-- NOM, Prénom 2 :


-- Préparation : création de la relation Annuaire
-- ===========
@vider
@annuaire

@liste

-- schéma des relations :
desc Annuaire
desc BigAnnuaire


select count(*) as nb_personnes from BigAnnuaire;




-- Question préliminaire: Statistiques sur les tables
-- ==================================================

explain plan for
    select * from Annuaire;
@p3


explain plan for
    select * from BigAnnuaire;
@p3


explain plan for
    select distinct nom from BigAnnuaire;
@p3


explain plan for
    select distinct prenom from BigAnnuaire;
@p3


explain plan for
    select distinct age from BigAnnuaire;
@p3


explain plan for
    select distinct cp from BigAnnuaire;
@p3


select min(population), max(population)
from Ville;


-- =================================
-- Exercice 1 : Sélection avec index
-- =================================

-- a)
explain plan for
    select a.nom, a.prenom
    from BigAnnuaire a
    where a.age = 18;
@p3


-- b)
explain plan for
    select a.nom, a.prenom
    from BigAnnuaire a
    where a.age between 20 and 29;
@p3


-- c)
explain plan for
   select a.nom, a.prenom
   from BigAnnuaire a
   where a.age < 70 and (a.cp = 93000 or a.cp = 75000);
@p3


-- d)
explain plan for
    select a.nom, a.prenom
    from BigAnnuaire a
    where a.age = 20 and a.cp = 13000 and a.nom like 'T%';
@p3


-- Exercice 2: Sélection AVEC/SANS index
-- =====================================

-- a)
explain plan for
    select a.nom, a.prenom
    from BigAnnuaire a
    where a.age <= 30;
@p4

--COMPLETER




-- c)
explain plan for
    select a.nom, a.prenom
    from BigAnnuaire a
    where a.cp BETWEEN 50000 AND 81916;
@p4




-- Exercice 3. Comparaison de plans d'exécutions équivalents
-- =========================================================
explain plan for
   SELECT  /*+ index( a IndexAge) */   a.nom, a.prenom 
   FROM BigAnnuaire a WHERE a.age < 7;
@p4


explain plan for
   SELECT /*+  no_index( a IndexAge) */   a.nom, a.prenom
   FROM BigAnnuaire a WHERE a.age < 7;
@p4


-- b)

explain plan for
   SELECT  /*+ index( a IndexAge) */   a.nom, a.prenom 
   FROM BigAnnuaire a WHERE a.age > 19;
@p4


explain plan for
   SELECT /*+  no_index( a IndexAge) */   a.nom, a.prenom
   FROM BigAnnuaire a WHERE a.age > 19;
@p4



--c)
explain plan for
    select /*+ index(a IndexAge) no_index(a IndexCp)  */  a.nom, a.prenom 
    from BigAnnuaire a where a.age = 18 and a.cp = 75000;
@p4



-- Exercice 4: Jointure avec index
-- ==================================

-- a) avec le "petit" Annuaire
explain plan for
    select a.nom, a.prenom, v.ville
    from Annuaire a, Ville v
    where a.cp = v.cp
    and a.age=18;
@p3


-- b) avec BigAnnuaire
explain plan for
    select a.nom, a.prenom, v.ville
    from BigAnnuaire a, Ville v
    where a.cp = v.cp
    and a.age=18;
@p3
    


--c)
explain plan for
    select a.nom, a.prenom, v.ville
    from BigAnnuaire a, Ville v
    where a.cp = v.cp
    and v.population >= 985000;
@p3




-- Exercice 5: Autres Requetes 
-- ===========================

-- voir les requetes sur l'énoncé en ligne

--a) Requête avec group by
EXPLAIN plan FOR
    SELECT age, COUNT(*)
    FROM BigAnnuaire a
    GROUP BY age;
@p3


--b) Requête avec group by having
EXPLAIN plan FOR
    SELECT age, COUNT(*)
    FROM BigAnnuaire a
    GROUP BY age
    HAVING COUNT(*) > 200;
@p3


--c) Requête min max
EXPLAIN plan FOR
    SELECT MIN(cp), MAX(cp)
    FROM BigAnnuaire a;
@p3


--d) Requête avec not in
EXPLAIN plan FOR
    SELECT a.nom, a.prenom
    FROM BigAnnuaire a
    WHERE a.prenom NOT IN ( SELECT b.prenom
                            FROM BigAnnuaire b
                            WHERE b.age<=7);
@p3


--e) Requête avec not exists
EXPLAIN plan FOR
    SELECT a.nom, a.prenom
    FROM BigAnnuaire a
    WHERE NOT EXISTS ( SELECT *
                       FROM BigAnnuaire b
                       WHERE b.prenom = a.prenom
                       AND b.age < a.age);
@p3


--f) Requête avec minus : les codes postaux des villes qui n'ont pas de centenaire.
EXPLAIN plan FOR
    SELECT cp
    FROM BigAnnuaire a
    minus
    SELECT cp
    FROM BigAnnuaire b
    WHERE b.age>=100;
@p3


--g) requête avec where age >= ALL (…)
EXPLAIN plan FOR
    SELECT a.nom, a.prenom
    FROM BigAnnuaire a
    WHERE a.age >= ALL (SELECT b.age
                       FROM BigAnnuaire b
                       WHERE b.cp = 75000);
@p3


--h) Requete avec UNION, avec UNION ALL, avec une division, … (no request giving)



-- Exercice 6: Documentation et Requetes sur le catalogue
-- ======================================================
COLUMN TABLE_NAME format A20
SELECT TABLE_NAME, blocks, num_rows as cardinalite
FROM user_tables;


-- info sur la taille des index
column table_name format A10
column index_name format A10
--
select table_name, index_name, blevel, distinct_keys, leaf_blocks,
avg_leaf_blocks_per_key, avg_data_blocks_per_key
from user_indexes
where table_name = 'ANNUAIRE';

select table_name, index_name, blevel, distinct_keys, leaf_blocks,
avg_leaf_blocks_per_key, avg_data_blocks_per_key
from all_indexes
where table_name = 'BIGANNUAIRE';


--Décrit le domaine de chaque attribut
COLUMN TABLE_NAME format A20
    COLUMN column_name format A20
    SELECT TABLE_NAME, column_name, utl_raw.cast_to_number(low_value) AS borneInf,  utl_raw.cast_to_number(high_value) AS borneSup, num_distinct, histogram
    FROM user_tab_cols
    WHERE data_type = 'NUMBER';
-- Exercice 5: Autres Requetes 
-- ===========================

-- voir les requetes sur l'énoncé en ligne

--a) Requête avec group by
EXPLAIN plan FOR
    SELECT age, COUNT(*)
    FROM BigAnnuaire a
    GROUP BY age;
@p3


--b) Requête avec group by having
EXPLAIN plan FOR
    SELECT age, COUNT(*)
    FROM BigAnnuaire a
    GROUP BY age
    HAVING COUNT(*) > 200;
@p3


--c) Requête min max
EXPLAIN plan FOR
    SELECT MIN(cp), MAX(cp)
    FROM BigAnnuaire a;
@p3


--d) Requête avec not in
EXPLAIN plan FOR
    SELECT a.nom, a.prenom
    FROM BigAnnuaire a
    WHERE a.prenom NOT IN ( SELECT b.prenom
                            FROM BigAnnuaire b
                            WHERE b.age<=7);
@p3


--e) Requête avec not exists
EXPLAIN plan FOR
    SELECT a.nom, a.prenom
    FROM BigAnnuaire a
    WHERE NOT EXISTS ( SELECT *
                       FROM BigAnnuaire b
                       WHERE b.prenom = a.prenom
                       AND b.age < a.age);
@p3


--f) Requête avec minus : les codes postaux des villes qui n'ont pas de centenaire.
EXPLAIN plan FOR
    SELECT cp
    FROM BigAnnuaire a
    minus
    SELECT cp
    FROM BigAnnuaire b
    WHERE b.age>=100;
@p3


--g) requête avec where age >= ALL (…)
EXPLAIN plan FOR
    SELECT a.nom, a.prenom
    FROM BigAnnuaire a
    WHERE a.age >= ALL (SELECT b.age
                       FROM BigAnnuaire b
                       WHERE b.cp = 75000);
@p3


--h) Requete avec UNION, avec UNION ALL, avec une division, … (no request giving)



-- Exercice 6: Documentation et Requetes sur le catalogue
-- ======================================================
COLUMN TABLE_NAME format A20
SELECT TABLE_NAME, blocks, num_rows as cardinalite
FROM user_tables;


-- info sur la taille des index
column table_name format A10
column index_name format A10
--
select table_name, index_name, blevel, distinct_keys, leaf_blocks,
avg_leaf_blocks_per_key, avg_data_blocks_per_key
from user_indexes
where table_name = 'ANNUAIRE';

select table_name, index_name, blevel, distinct_keys, leaf_blocks,
avg_leaf_blocks_per_key, avg_data_blocks_per_key
from all_indexes
where table_name = 'BIGANNUAIRE';


--Décrit le domaine de chaque attribut
COLUMN TABLE_NAME format A20
    COLUMN column_name format A20
    SELECT TABLE_NAME, column_name, utl_raw.cast_to_number(low_value) AS borneInf,  utl_raw.cast_to_number(high_value) AS borneSup, num_distinct, histogram
    FROM user_tab_cols
    WHERE data_type = 'NUMBER';
-- Exercice 5: Autres Requetes 
-- ===========================

-- voir les requetes sur l'énoncé en ligne

--a) Requête avec group by
EXPLAIN plan FOR
    SELECT age, COUNT(*)
    FROM BigAnnuaire a
    GROUP BY age;
@p3


--b) Requête avec group by having
EXPLAIN plan FOR
    SELECT age, COUNT(*)
    FROM BigAnnuaire a
    GROUP BY age
    HAVING COUNT(*) > 200;
@p3


--c) Requête min max
EXPLAIN plan FOR
    SELECT MIN(cp), MAX(cp)
    FROM BigAnnuaire a;
@p3


--d) Requête avec not in
EXPLAIN plan FOR
    SELECT a.nom, a.prenom
    FROM BigAnnuaire a
    WHERE a.prenom NOT IN ( SELECT b.prenom
                            FROM BigAnnuaire b
                            WHERE b.age<=7);
@p3


--e) Requête avec not exists
EXPLAIN plan FOR
    SELECT a.nom, a.prenom
    FROM BigAnnuaire a
    WHERE NOT EXISTS ( SELECT *
                       FROM BigAnnuaire b
                       WHERE b.prenom = a.prenom
                       AND b.age < a.age);
@p3


--f) Requête avec minus : les codes postaux des villes qui n'ont pas de centenaire.
EXPLAIN plan FOR
    SELECT cp
    FROM BigAnnuaire a
    minus
    SELECT cp
    FROM BigAnnuaire b
    WHERE b.age>=100;
@p3


--g) requête avec where age >= ALL (…)
EXPLAIN plan FOR
    SELECT a.nom, a.prenom
    FROM BigAnnuaire a
    WHERE a.age >= ALL (SELECT b.age
                       FROM BigAnnuaire b
                       WHERE b.cp = 75000);
@p3


--h) Requete avec UNION, avec UNION ALL, avec une division, … (no request giving)



-- Exercice 6: Documentation et Requetes sur le catalogue
-- ======================================================
COLUMN TABLE_NAME format A20
SELECT TABLE_NAME, blocks, num_rows as cardinalite
FROM user_tables;


-- info sur la taille des index
column table_name format A10
column index_name format A10
--
select table_name, index_name, blevel, distinct_keys, leaf_blocks,
avg_leaf_blocks_per_key, avg_data_blocks_per_key
from user_indexes
where table_name = 'ANNUAIRE';

select table_name, index_name, blevel, distinct_keys, leaf_blocks,
avg_leaf_blocks_per_key, avg_data_blocks_per_key
from all_indexes
where table_name = 'BIGANNUAIRE';


--Décrit le domaine de chaque attribut
COLUMN TABLE_NAME format A20
    COLUMN column_name format A20
    SELECT TABLE_NAME, column_name, utl_raw.cast_to_number(low_value) AS borneInf,  utl_raw.cast_to_number(high_value) AS borneSup, num_distinct, histogram
    FROM user_tab_cols
    WHERE data_type = 'NUMBER';
-- Exercice 5: Autres Requetes 
-- ===========================

-- voir les requetes sur l'énoncé en ligne

--a) Requête avec group by
EXPLAIN plan FOR
    SELECT age, COUNT(*)
    FROM BigAnnuaire a
    GROUP BY age;
@p3


--b) Requête avec group by having
EXPLAIN plan FOR
    SELECT age, COUNT(*)
    FROM BigAnnuaire a
    GROUP BY age
    HAVING COUNT(*) > 200;
@p3


--c) Requête min max
EXPLAIN plan FOR
    SELECT MIN(cp), MAX(cp)
    FROM BigAnnuaire a;
@p3


--d) Requête avec not in
EXPLAIN plan FOR
    SELECT a.nom, a.prenom
    FROM BigAnnuaire a
    WHERE a.prenom NOT IN ( SELECT b.prenom
                            FROM BigAnnuaire b
                            WHERE b.age<=7);
@p3


--e) Requête avec not exists
EXPLAIN plan FOR
    SELECT a.nom, a.prenom
    FROM BigAnnuaire a
    WHERE NOT EXISTS ( SELECT *
                       FROM BigAnnuaire b
                       WHERE b.prenom = a.prenom
                       AND b.age < a.age);
@p3


--f) Requête avec minus : les codes postaux des villes qui n'ont pas de centenaire.
EXPLAIN plan FOR
    SELECT cp
    FROM BigAnnuaire a
    minus
    SELECT cp
    FROM BigAnnuaire b
    WHERE b.age>=100;
@p3


--g) requête avec where age >= ALL (…)
EXPLAIN plan FOR
    SELECT a.nom, a.prenom
    FROM BigAnnuaire a
    WHERE a.age >= ALL (SELECT b.age
                       FROM BigAnnuaire b
                       WHERE b.cp = 75000);
@p3


--h) Requete avec UNION, avec UNION ALL, avec une division, … (no request giving)



-- Exercice 6: Documentation et Requetes sur le catalogue
-- ======================================================
COLUMN TABLE_NAME format A20
SELECT TABLE_NAME, blocks, num_rows as cardinalite
FROM user_tables;


-- info sur la taille des index
column table_name format A10
column index_name format A10
--
select table_name, index_name, blevel, distinct_keys, leaf_blocks,
avg_leaf_blocks_per_key, avg_data_blocks_per_key
from user_indexes
where table_name = 'ANNUAIRE';

select table_name, index_name, blevel, distinct_keys, leaf_blocks,
avg_leaf_blocks_per_key, avg_data_blocks_per_key
from all_indexes
where table_name = 'BIGANNUAIRE';


--Décrit le domaine de chaque attribut
COLUMN TABLE_NAME format A20
    COLUMN column_name format A20
    SELECT TABLE_NAME, column_name, utl_raw.cast_to_number(low_value) AS borneInf,  utl_raw.cast_to_number(high_value) AS borneSup, num_distinct, histogram
    FROM user_tab_cols
    WHERE data_type = 'NUMBER';

explain plan for select * from annuaire;
@p4
