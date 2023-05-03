--------GESTION Utilisateurs ------

create or replace package pac_gestion_utilisateurs
as 
procedure ajouterUtil(login  in varchar2,pwd in varchar2);
procedure modifierUtil(login in varchar2,pwd in varchar2) ;
procedure supprimerUtil(login in varchar2);
FUNCTION rechercherUtil(login in varchar2) RETURN BOOLEAN ;
erreurGlobal  Exception;
erreurUtilisateur EXCEPTION;
End;


create or replace package body pac_gestion_utilisateurs As
 procedure ajouterUtil(login in varchar2,pwd in varchar2) AS
message varchar2(200);
vnbr number;
begin
select count(username) into vnbr
from SYS.all_users
where upper(login)=upper(username);
IF (vnbr!=0) THEN
		raise erreurGlobal;
ELSE
        message := 'create user ' || login || ' identified by ' || pwd ;
        EXECUTE IMMEDIATE ( message ); 
END IF;
EXCEPTION
WHEN erreurGlobal THEN DBMS_OUTPUT.put_line('cette utilisateur de nom :' ||login ||' dej? existant !');
END;


procedure modifierUtil(login in varchar2,pwd in varchar2) As
message varchar2(200);
vnbr number;
begin
select count(username) into vnbr
from SYS.all_users
where upper(login)=upper(username);
IF (vnbr!=0) THEN
      message := 'alter user ' || login || ' identified by ' || pwd  ;
      EXECUTE IMMEDIATE ( message ); 
END IF;
EXCEPTION
WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.put_line('cette utilisateur de nom :' ||login ||' dej? existant !');
END;


procedure supprimerUtil(login in varchar2 ) AS
message varchar2(200);
vnbr number;
BEGIN 
select count (username) into vnbr
FROM SYS.all_users
WHERE upper(login)=upper(username);
IF (vnbr=0) THEN 
RAISE erreurUtilisateur;
ELSE 
message := 'drop user ' || login || 'cascade'  ;
EXECUTE IMMEDIATE ( message ); 
END IF;
EXCEPTION
WHEN erreurUtilisateur THEN DBMS_OUTPUT.put_line('cette utilisateur de nom :' ||login ||' dej? existant !');
END ;


FUNCTION rechercherUtil(login in varchar2) 
RETURN BOOLEAN IS
test BOOLEAN := FALSE ;
vnbr NUMBER ;
BEGIN
SELECT count(username) INTO vnbr
FROM SYS.all_users
WHERE UPPER(username) = UPPER (login);
IF (vnbr>0) THEN 
test:= TRUE ;
END IF;
RETURN test;
END;

END;


