---------CREATION BASE ET TRIGGER -----------

CREATE TABLE Lieu
	(idLieu INTEGER PRIMARY KEY,
	NomLieu VARCHAR2 (30) NOT NULL,
	Adresse VARCHAR2 (100) NOT NULL,
      capacite NUMBER NOT NULL);

create or replace trigger tri_cap_lieu before insert or update on Lieu for each row 
BEGIN
  IF  :new.capacite < 100 and :new.capacite >2000
  THEN
    RAISE_APPLICATION_ERROR( -20011, 
          'Invalid capacity , it must be between 100 and 2000' 
           );
  END IF;
END;


CREATE TABLE Artiste
	(idArt INTEGER PRIMARY KEY,
	NomArt VARCHAR2 (30) NOT NULL,
	PrenomArt VARCHAR2 (30) NOT NULL,
        specialite VARCHAR2 (10) NOT NULL);
        
alter table artiste add constraint specialiste check (specialite IN ('danseur','acteur','musicien','magicien','imitateur','humoriste','chanteur'));
       



CREATE TABLE SPECTACLE 
	(idSpec INTEGER PRIMARY KEY,
	Titre VARCHAR2 (40) NOT NULL,
         dateS DATE NOT NULL,
         h_debut NUMBER(4,2) NOT NULL,
	 dureeS NUMBER(4,2) NOT NULL,
         nbrSpectateur INTEGER NOT NULL,
	 idLieu INTEGER,
	
	CONSTRAINT chk_spect_durees CHECK (dureeS BETWEEN 1 AND 4),
        CONSTRAINT FK_spect_Lieux FOREIGN KEY(idLieu)REFERENCES Lieu (idLieu));

CREATE OR REPLACE TRIGGER trig_verif_date
  BEFORE INSERT OR UPDATE ON SPECTACLE
  FOR EACH ROW
BEGIN
    if :new.dateS <= sysdate then 
    RAISE_APPLICATION_ERROR( -20012, 
          'Invalid date Spectacle: dateS must be greater than the current date - value = ' || 
          to_char( :new.dateS, 'YYYY-MM-DD HH24:MI:SS' ) );
    end if;      
END;

CREATE OR REPLACE TRIGGER trig_verif_nbr_places
  BEFORE INSERT OR UPDATE ON SPECTACLE
  FOR EACH ROW
DECLARE
cap lieu.capacite%type;
BEGIN
  select capacite into cap from lieu
  where lieu.idlieu=:new.idspec;   
  IF( :new.nbrSpectateur > cap)
  THEN
    RAISE_APPLICATION_ERROR(-20015,'vous avez depasser la capacite!'); 
  END IF;
END;




CREATE TABLE Rubrique
	(idRub INTEGER PRIMARY KEY, 
	 idSpec INTEGER NOT NULL, 
	 idArt INTEGER NOT NULL, 
	 H_debutR NUMBER(4,2) NOT NULL, 
         dureeRub NUMBER(4,2) NOT NULL, 
         type VARCHAR2(10), 
      CONSTRAINT fk_rub_spect FOREIGN KEY(idSpec) REFERENCES SPECTACLE(idSpec) ON DELETE CASCADE,
CONSTRAINT fk_rub_art FOREIGN KEY(idArt)  REFERENCES Artiste(idArt) ON DELETE CASCADE );


CREATE OR REPLACE TRIGGER trig_verif_rubrique_date_duree
  BEFORE INSERT OR UPDATE ON Rubrique
  FOR EACH ROW
DECLARE 
varDate spectacle.dateS%type;
varDuree spectacle.dureeS%type;
varHeure spectacle.h_debut%type;
errDate exception;
errDuree exception;
errHeure exception;
BEGIN
  select dateS,dureeS,h_debut into varDate,varDuree,varHeure from spectacle
  where SPECTACLE.idSpec=:new.idspec ;   
    IF( :new.H_debutR > varHeure)
  THEN
    RAISE errHeure;
  END IF;
      IF( :new.dureeRub > varDuree)
  THEN
    RAISE errDuree;
  END IF;
  
  EXCEPTION 
  when errDuree then 
  dbms_output.put_line('duree finie apr?s celle du spectacle');
  when errHeure then 
  dbms_output.put_line('date invalide !!');

END;

alter table rubrique 
ADD CONSTRAINT ch_type check (type IN ('comedie','theatre','dance','imitation','magie','musique','chant'));


CREATE OR REPLACE TRIGGER trig_verif_nbr_rubrique
  BEFORE INSERT OR UPDATE ON SPECTACLE
  FOR EACH ROW
DECLARE 
cap lieu.capacite%type;
vnbr number;
BEGIN
  select count(idspec) into vnbr from  rubrique
  where rubrique.idspec= :new.idspec;   
  IF vnbr >= 3 then 
    RAISE_APPLICATION_ERROR(-20016,'deja contient  3 rubrique impossible d ajouter !'); 
  END IF;
END;

CREATE TABLE Billet
	(idBillet INTEGER PRIMARY KEY,
	categorie VARCHAR2(10),
	prix NUMBER(5,2) NOT NULL,

	idspec INTEGER NOT NULL ,
	Vendu VARCHAR(3) NOT NULL, 

CONSTRAINT chk_billet_PRIX CHECK(prix BETWEEN 10 AND 300),
CONSTRAINT fk_billet_spec FOREIGN KEY (idspec)REFERENCES spectacle,
CONSTRAINT chk_billet_vendu CHECK(vendu IN ('Oui','Non'))
);

  CREATE OR REPLACE TRIGGER trig_categorie_billet
  BEFORE INSERT OR UPDATE ON Billet
  FOR EACH ROW
BEGIN
if UPPER(:new.Categorie) not in ('GOLD','SILVER','NORMALE') then 
RAISE_APPLICATION_ERROR(-200156,'categorie n est pas gold ni silver ni normale'); 
end if ;
end;

  CREATE OR REPLACE TRIGGER trig_unicite_billet
  BEFORE INSERT OR UPDATE ON Billet
  FOR EACH ROW
  declare 
  nombre number;
BEGIN
select count(idspec) into nombre
from billet where idbillet=:new.idbillet ;
if(nombre>0) then 
raise_application_error(-50000,'cette  billet est utilis? dej? !!');
end if;
end;

CREATE TABLE CLIENT
      ( idClt INTEGER PRIMARY KEY,
       nomClt VARCHAR(40),
       prenomClt VARCHAR(40),
       tel VARCHAR(8),
       email VARCHAR(40) NOT NULL,
       motP VARCHAR(40) NOT NULL
);

create or replace trigger trig_verif_client 
before insert on  client 
for each row 
declare 
begin 
 if :new.email not like '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$' then 
raise_application_error(-20016,'email invalide');
end if;
if :new.tel not like '[0-9]{8}' then
raise_application_error(-20017,'num telephone invalide');
end if ; 
end;













