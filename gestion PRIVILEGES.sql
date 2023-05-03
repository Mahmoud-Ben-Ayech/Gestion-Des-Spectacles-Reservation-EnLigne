--------GESTION privileges  ------



create or replace procedure privilegesGestComm(username in varchar2 ) IS 
    message VARCHAR (200);
    errGest EXCEPTION;
    Begin 
    	if(pac_gestion_utilisateurs.rechercherUtil(username))then
         message := 'GRANT INSERT ,DELETE , CREATE SESSION ,SELECT, UPDATE(nomClt,prenomClt,tel,email,motP) ON CLIENT  TO ' || username;
        EXECUTE IMMEDIATE ( message );
        message := 'GRANT INSERT ,DELETE , CREATE SESSION,SELECT, UPDATE(DATES,H_DEBUT,NBRSPECTATEUR)  ON BILLET  TO ' || username;
        EXECUTE IMMEDIATE ( message );
        else 
            raise errGest;
        end if;
    EXCEPTION 
    when errGest then DBMS_OUTPUT.put_line('cette utilisateur de nom :' ||username ||' dej? existant !');
END privilegesGestComm;




create or replace procedure privilegesPlanif(username in varchar2 ) IS 
    message VARCHAR (200);
    erreurPlan EXCEPTION;
    Begin 
    	if(pac_gestion_utilisateurs.rechercherUtil(username))then
        message := 'GRANT CREATE SESSION , INSERT ,DELETE , SELECT, UPDATE(NOMLIEU,ADRESSE,CAPACITE)  ON LIEU  TO ' || username;
        EXECUTE IMMEDIATE ( message );
        message := 'GRANT CREATE SESSION,INSERT,DELETE,SELECT, UPDATE(TITRE,DATES,H_DEBUT,NBRSPECTATEUR) ON SPECTACLE  TO ' || username;
        EXECUTE IMMEDIATE ( message );
        message := 'GRANT CREATE SESSION,INSERT,DELETE,SELECT, UPDATE(H_DEBUTR,DUREERUB,TYPE)  ON RUBRIQUE  TO ' || username;
        EXECUTE IMMEDIATE ( message );
        
        else 
            raise erreurPlan;
        end if;
    EXCEPTION 
    when erreurPlan then DBMS_OUTPUT.put_line(' cette utilisateur de nom :' ||username ||' dej? existant !');
END privilegesPlanif;



