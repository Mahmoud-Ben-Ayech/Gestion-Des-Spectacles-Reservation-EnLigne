--------GESTION Spectacle  ------

CREATE OR REPLACE PACKAGE pac_gestion_spectacles 
AS 
PROCEDURE ajouer_spectacle(idspect spectacle.idSpec%TYPE, titrespect spectacle.titre%TYPE,datespect spectacle.dateS%TYPE,
heuredebut spectacle.H_Debut%TYPE, duree spectacle.durees%TYPE,nbrspect spectacle.nbrSpectateur%TYPE,idlie spectacle.idLieu%TYPE) ;

PROCEDURE ajouter_spec_inserer(idspect spectacle.idSpec%TYPE, titree spectacle.titre%TYPE,datesp spectacle.dateS%TYPE,
hdebut spectacle.H_Debut%TYPE, duree spectacle.durees%TYPE,nbrspect spectacle.nbrSpectateur%TYPE,idlieu spectacle.idLieu%TYPE);

FUNCTION cherche_spec_identif(id spectacle.idspec%type) RETURN boolean;

FUNCTION cherche_spec_titre(titresp spectacle.titre%type) RETURN boolean;

PROCEDURE annuler_spectacle( id spectacle.idspec%type )  ; 

PROCEDURE modifier_spec(id spectacle.idspec%type,titresp spectacle.titre%TYPE,datesp spectacle.dateS%TYPE, 
hdebut spectacle.H_Debut%TYPE, duree spectacle.durees%TYPE,nbspctr spectacle.nbrSpectateur%TYPE,idlie spectacle.idLieu%TYPE);

END;

ALTER TABLE spectacle MODIFY h_debut  NULL; -------------------modifier contrainte

------------------------vue----------
CREATE VIEW evenement_futur 
AS SELECT idspec,titre,dates FROM SPECTACLE WHERE dates > SYSDATE;
--------------------------------- 



create or replace package body pac_gestion_spectacles As

PROCEDURE ajouer_spectacle(idspect spectacle.idSpec%TYPE, titrespect spectacle.titre%TYPE,datespect spectacle.dateS%TYPE,
heuredebut spectacle.H_Debut%TYPE, duree spectacle.durees%TYPE,nbrspect spectacle.nbrSpectateur%TYPE,idlie spectacle.idLieu%TYPE) 
IS vnbr number;
vnblieu number;
errSPEC EXCEPTION;
errreservation EXCEPTION;
BEGIN 
SELECT COUNT(idspec) INTO vnbr FROM spectacle 
WHERE idspec=idspect;
SELECT COUNT(idspec) INTO vnblieu 
FROM spectacle 
WHERE idlieu=idlie AND dateS=datespect AND h_debut=heuredebut;
IF(vnbr>0) THEN RAISE errSPEC; 
ELSE IF (vnblieu>0) THEN RAISE errreservation; 
ELSE INSERT INTO spectacle VALUES(idspect,titrespect,datespect,heuredebut,duree,nbrspect,idlie); 
END IF; 
END IF; 
EXCEPTION
WHEN errreservation THEN 
DBMS_OUTPUT.put_line('Le lieu programm? pour ce spectacle: '||idlie||'est d?ja r?serv?!');
WHEN errSPEC THEN 
DBMS_OUTPUT.put_line('Le spectacle: '||idspect||'d?ja existe!'); 
END ajouer_spectacle;

PROCEDURE ajouter_spec_inserer(idspect spectacle.idSpec%TYPE, titree spectacle.titre%TYPE,datesp spectacle.dateS%TYPE,
hdebut spectacle.H_Debut%TYPE, duree spectacle.durees%TYPE,nbrspect spectacle.nbrSpectateur%TYPE,idlieu spectacle.idLieu%TYPE) 
IS nombre number; 
errSPEC EXCEPTION;
BEGIN
SELECT COUNT(idSpec) INTO nombre
FROM spectacle
WHERE idspec=idspect; 
IF(nombre>0) THEN RAISE errSPEC; 
ELSE INSERT INTO spectacle VALUES(idspect,titree,datesp,hdebut,duree,nbrspect,idlieu); 
END IF; 
EXCEPTION 
WHEN errSPEC THEN DBMS_OUTPUT.put_line('Le spectacle: '||idspect||'d?ja existe!'); 
END ajouter_spec_inserer;

FUNCTION cherche_spec_titre(titresp spectacle.titre%type) RETURN boolean 
IS 
nbr number;
BEGIN 
SELECT COUNT(idspec) into nbr FROM spectacle
WHERE UPPER(titre) LIKE UPPER(titresp);
IF(nbr>0) then return true;
END IF;
return false;
END cherche_spec_titre ;

FUNCTION cherche_spec_identif(id spectacle.idspec%type) RETURN boolean 
IS 
nbr number;
BEGIN
SELECT COUNT(idspec) into nbr 
FROM spectacle 
WHERE idspec=id; 
IF(nbr>0) then return true; 
END IF;
return false;
END cherche_spec_identif ;

PROCEDURE annuler_spectacle( id spectacle.idspec%type ) 
IS 
nbr number;
errAbsanceSpectacle EXCEPTION;
errSpectacleTermine EXCEPTION; 
BEGIN 
IF (NOT cherche_spec_identif(id)) THEN RAISE errAbsanceSpectacle; 
ELSE SELECT COUNT(idspec) INTO nbr FROM evenement_futur WHERE idspec=id; 
IF(nbr=0) THEN RAISE errSpectacleTermine;
ELSE UPDATE spectacle SET h_debut=NULL WHERE idspec=id; 
END IF; 
END IF ;
EXCEPTION 
WHEN errSpectacleTermine THEN 
DBMS_OUTPUT.put_line('Le spectacle d id : '|| id ||'a d?ja pass? !');
WHEN errAbsanceSpectacle THEN 
DBMS_OUTPUT.put_line('Le spectacle d id : '|| id ||'n existe pas!'); 
END annuler_spectacle;

PROCEDURE modifier_spec(id spectacle.idspec%type,titresp spectacle.titre%TYPE,datesp spectacle.dateS%TYPE, hdebut spectacle.H_Debut%TYPE, 
duree spectacle.durees%TYPE,nbspctr spectacle.nbrSpectateur%TYPE,idlie spectacle.idLieu%TYPE) 
IS 
errAbsanceSpectacle EXCEPTION;
BEGIN 
IF (NOT cherche_spec_identif(id) ) THEN RAISE errAbsanceSpectacle;
ELSE 
    IF (titresp IS NOT NULL) 
       THEN UPDATE spectacle SET titre=titresp; 
    ELSE IF(datesp IS NOT NULL) THEN UPDATE spectacle SET dateS=datesp; 
    ELSE IF(hdebut IS NOT NULL) THEN UPDATE spectacle SET h_debut=hdebut; 
    ELSE IF(duree IS NOT NULL) THEN UPDATE spectacle SET durees=duree; 
    ELSE IF(nbspctr IS NOT NULL) THEN UPDATE spectacle SET nbrSpectateur=nbspctr; 
    ELSE IF(idlie IS NOT NULL) THEN UPDATE spectacle SET idlieu=idlie; 
    END IF;
    END IF;
    END IF;
    END IF;
    END IF;
    END IF;
END IF; 
EXCEPTION
WHEN errAbsanceSpectacle THEN DBMS_OUTPUT.put_line('Le spectacle: '||id||'n''existe pas!');
END modifier_spec;

END;



--------GESTION Rubrique  ------

create or replace package pac_gestion_rubriques 
as 
PROCEDURE chercherRub ( idSpec in Spectacle.idSpec%type ,  nomArt in Artiste.nomArt%type   );

PROCEDURE supprimerRub(idRub in Rubrique.idrub%type);

procedure  ajouterRub( idRub in Rubrique.idRub%type ,  idSpect in  Rubrique.idSpec%type ,
idArt in  Rubrique.idArt%type ,heure in Rubrique.H_debutR%type, duree_rub in Rubrique.dureeRub%type, typeRub in Rubrique.type%type);

Procedure modifierRub(idRub1 in Rubrique.idRub%type ,idArt in Artiste.idart%type,
duree_rub in  Rubrique.dureeRub%type, heure in Rubrique.H_debutR%type);

End  ;


create or replace package body pac_gestion_rubriques  As

PROCEDURE chercherRub ( idSpec in Spectacle.idSpec%type ,  nomArt in Artiste.nomArt%type   ) is
Cursor CurRubrique is 
select Rub.idrub , Rub.idspec,Rub.idart,Rub.h_debutr,Rub.dureeRub,type
from Rubrique Rub , Artiste 
where Rub.idart=Artiste.idart  AND  idSpec = Rub.idSpec OR  nomArt =Artiste.nomart ;
Vcurrub CurRubrique%Rowtype;
BEGIN 
OPEN CurRubrique;

LOOP
FETCH CurRubrique into Vcurrub;
EXIT WHEN CurRubrique%NOTFOUND;
DBMS_OUTPUT.PUT_LINE('cette  Rubrique possede :  id :'|| Vcurrub.idrub || ' et d id spectacle :'|| Vcurrub.idspec || 'qui d?bute'|| Vcurrub.h_debutr ||
' de duree '|| Vcurrub.dureerub || 'de type:'|| Vcurrub.type);
end LOOP;

CLOSE CurRubrique;
EXCEPTION 
WHEN NO_DATA_FOUND then DBMS_OUTPUT.PUT_LINE('Rubrique n existe pas !!');
END chercherRub ;



PROCEDURE supprimerRub(idRub in Rubrique.idrub%type) is 
idRub1 Rubrique.idrub%type;
dateRub Spectacle.dateS%type;
errRub   Exception ;
errRub1  Exception ;
begin 
select idrub into idRub1
from rubrique 
where idRub1=idRub;
if(idRub1 is null ) then raise errRub;
else 
        select spec.dateS into dateRub 
        from rubrique rub,spectacle spec 
        where rub.idrub=idRub 
        and  spec.idSpec=rub.idSpec ; 
        if(dateRub > SYSDATE) then 
        delete from rubrique where idrub=idRub;
        else 
        raise errRub1;
        END IF;
END if ;
EXCEPTION 
 when  errRub then     DBMS_OUTPUT.PUT_LINE('Aucun rubrique associe a cette id : ' || idRub);
 when errRub1 then     DBMS_OUTPUT.PUT_LINE('Rubrique deja pasee!!');

END  supprimerRub;








 procedure  ajouterRub( idRub in Rubrique.idRub%type ,  idSpect in  Rubrique.idSpec%type ,
idArt in  Rubrique.idArt%type ,heure in Rubrique.H_debutR%type, duree_rub in Rubrique.dureeRub%type, typeRub in Rubrique.type%type) 
IS 
idS  Rubrique.idSpec%type;
BEGIN 
select  idSpec into idS 
from Spectacle 
where idspec=idSpect;
INSERT into rubrique values( idRub , idSpect , idArt , heure ,duree_rub , typeRub) ;
EXCEPTION
when NO_DATA_FOUND then DBMS_OUTPUT.PUT_LINE('pas de spectacle associee a cette rubrique !! ');
END  ajouterRub;

Procedure modifierRub(idRub1 in Rubrique.idRub%type ,idArt in Artiste.idart%type,
duree_rub in  Rubrique.dureeRub%type, heure in Rubrique.H_debutR%type) is

idR Rubrique.idSpec%type;

Begin 
select idSpec into idR
from Rubrique  
where idRub=idRub1;

UPDATE RUBRIQUE SET 
 idart=idArt,
 dureeRub=duree_rub ,
H_debutR=heure;
dbms_output.put_line('Mis a jour avec succ?s!');
EXCEPTION 
 when NO_DATA_FOUND then DBMS_OUTPUT.PUT_LINE('pas de spectacle associee a cette rubrique !!');
END modifierRub;

 END ;

-----Triggers de Rubrique ------

CREATE OR REPLACE TRIGGER trig_verif_insert_rub 
BEFORE INSERT ON RUBRIQUE
FOR EACH ROW
DECLARE
verifArtist number; 
dureeTotal number;
hDeb spectacle.h_debut%type;
durS spectacle.durees%type;
hFin number := :NEW.h_debutr + :NEW.dureerub;
artiste_introuvable exception;
typeArt artiste.specialite%type;
vnbr number;

BEGIN

SELECT SUM(dureerub) INTO dureeTotal
from rubrique rub, spectacle spec
where  rub.idspec=:NEW.idspec
and spec.idspec=rub.idspec ;

SELECT spec.h_debut ,spec.durees into hDeb ,durS
from rubrique rub,spectacle spec
where  rub.idspec=:NEW.idspec
and spec.idspec=rub.idspec  ;

IF :NEW.h_debutr < hDeb or :NEW.h_debutr > hDeb+durS then
  RAISE_APPLICATION_ERROR(-20111,'temps de debut de rubrique est invalide !!');
ELSIF :NEW.dureerub+dureeTotal> durS then 
     RAISE_APPLICATION_ERROR(-20112,'duree de rubrique superieure a duree de spectacle !!');
ELSE 

-- check if artiste existe

select count(idart) into verifArtist 
from artiste where
idart = :NEW.idart;
if verifArtist =0 then 
     RAISE_APPLICATION_ERROR(-23111,'pas d artiste trouvee');
end if;
select specialite into typeArt 
from artiste 
where   idart = :NEW.idart;

CASE (upper(typeArt))
WHEN 'MAGICIEN' THEN :NEW.type := 'MAGIE';
WHEN 'IMITATEUR' THEN :NEW.type := 'IMITATION';
WHEN 'DANSEUR' THEN :NEW.type := 'DANSE';
WHEN 'ACTEUR' THEN :NEW.type := 'THEATRE';
WHEN 'MUSICIEN' THEN :NEW.type := 'MUSIQUE';
WHEN 'CHANTEUR' THEN :NEW.type := 'CHANT';
WHEN 'HUMORISTE' THEN :NEW.type := 'HUMOUR';
END case;

select count(*) into vnbr
from (select h_debutr,h_debutr+dureerub  as heureFin
      from rubrique
      where rubrique.idart = :NEW.idart)
where( :NEW.h_debutr >= h_debutr AND :NEW.h_debutr < heureFin)
or ( hFin > h_debutr and hFin <= heureFin )
or (:NEW.h_debutr <= h_debutr and hFIN >= heureFin);
if vnbr !=0 then  RAISE_APPLICATION_ERROR(-21502,'artiste non disponible');
else  pac_gestion_rubriques.ajouterRub(:NEW.idrub,:NEW.idspec,:NEW.idart,:NEW.h_debutr,:NEW.dureerub,:NEW.type);
end if;
end if;
end;


CREATE OR REPLACE TRIGGER trig_verif_modif_rub 
BEFORE INSERT ON RUBRIQUE
FOR EACH ROW
DECLARE

dureeTotal number;
durS spectacle.durees%type;
hDeb spectacle.h_debut%type;
verifArtist number; 
artiste_introuvable exception;
typeArt artiste.specialite%type;
vnbr number;
hFin number := :NEW.h_debutr + :NEW.dureerub;

BEGIN

SELECT SUM(dureerub) INTO dureeTotal
from rubrique rub, spectacle spec
where  rub.idspec=:NEW.idspec
and spec.idspec=rub.idspec ;

SELECT spec.h_debut ,spec.durees into hDeb ,durS
from rubrique rub,spectacle spec
where  rub.idspec=:NEW.idspec
and spec.idspec=rub.idspec  ;

IF :NEW.h_debutr < hDeb or :NEW.h_debutr > hDeb+durS then
  RAISE_APPLICATION_ERROR(-20111,'temps de debut de rubrique est invalide !!');
ELSIF :NEW.dureerub+dureeTotal> durS then 
     RAISE_APPLICATION_ERROR(-20112,'duree de rubrique superieure a duree de spectacle !!');
ELSE 

-- check if artiste existe

select count(idart) into verifArtist 
from artiste where
idart = :NEW.idart;
if verifArtist =0 then 
     RAISE_APPLICATION_ERROR(-23111,'pas d artiste trouvee');
end if;
select specialite into typeArt 
from artiste 
where   idart = :NEW.idart;

CASE (upper(typeArt))
WHEN 'MAGICIEN' THEN :NEW.type := 'MAGIE';
WHEN 'IMITATEUR' THEN :NEW.type := 'IMITATION';
WHEN 'DANSEUR' THEN :NEW.type := 'DANSE';
WHEN 'ACTEUR' THEN :NEW.type := 'THEATRE';
WHEN 'MUSICIEN' THEN :NEW.type := 'MUSIQUE';
WHEN 'CHANTEUR' THEN :NEW.type := 'CHANT';
WHEN 'HUMORISTE' THEN :NEW.type := 'HUMOUR';
END case;

select count(*) into vnbr
from (select h_debutr,h_debutr+dureerub  as heureFin
      from rubrique
      where rubrique.idart = :NEW.idart)
where( :NEW.h_debutr >= h_debutr AND :NEW.h_debutr < heureFin)
or ( hFin > h_debutr and hFin <= heureFin )
or (:NEW.h_debutr <= h_debutr and hFIN >= heureFin);
if vnbr !=0 then  RAISE_APPLICATION_ERROR(-21502,'artiste non disponible');
else  pac_gestion_rubriques.modifierRub(:NEW.idrub,:NEW.idart,:NEW.h_debutr,:NEW.dureerub);
end if;
end if;
end;