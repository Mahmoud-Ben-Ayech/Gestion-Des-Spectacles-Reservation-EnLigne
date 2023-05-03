-------REMPLISSAGE BDD--------


create sequence seq_spectacle increment by 1 start with 1;
create sequence seq_Artiste  increment by 10 start with 100;
create sequence seq_Billet  increment by 1 start with  1;
create sequence seq_client increment by 10 start with 100;
create sequence seq_rubrique increment by 1 start with 1;


insert into  Artiste values(seq_Artiste.nextval,'mohamed ','hsan','danseur');
insert into  Artiste values(seq_Artiste.nextval,'med','jomaa','musicien');
insert into  Artiste values(seq_Artiste.nextval,'abid','lamia','magicien');
insert into  Artiste values(seq_Artiste.nextval,'lamina','kamel','chanteur');
insert into  Artiste values(seq_Artiste.nextval,'mbappe','kelyan','humoriste');

insert into spectacle values(seq_spectacle.nextval,'festival','31-Dec-22',12,3,10,10);
insert into  spectacle values(seq_spectacle.nextval,'watchers','31-Dec-22',10,2,10,6);
insert into  spectacle values(seq_spectacle.nextval,'dachra','31-Dec-22',20,1,10,7);
insert into   spectacle values(seq_spectacle.nextval,'one missed call','31-Dec-22',20,3,10,9);
insert into   spectacle values(seq_spectacle.nextval,'creed','31-Dec-22',2,1,2,3);

insert into  Billet values(seq_Billet.nextval,'gold',50,3,'Oui');
insert into  Billet values(seq_Billet.nextval,'silver',66,5,'Oui');
insert into  Billet values(seq_Billet.nextval,'normale',77,4,'Non');
insert into  Billet values(seq_Billet.nextval,'gold',70,7,'Non');
insert into  Billet values(seq_Billet.nextval,'normale',50,6,'Oui');


insert into  rubrique values(seq_rubrique.nextval,3,100,10,1,'comedie');
insert into  rubrique values(seq_rubrique.nextval,7,140,10,1,'theatre');
insert into  rubrique values(seq_rubrique.nextval,5,120,20,1,'imitation');
insert into   rubrique values(seq_rubrique.nextval,4,130,20,1,'musique');
insert into   rubrique values(seq_rubrique.nextval,6,110,20,1,'chant');

insert into  client values(seq_client.nextval,'kamel','ali','22132456','Ali@gmail.com','123');
insert into  client values(seq_client.nextval,'jlasi','hamed','23456789','hamed@gmail.com','124');
insert into  client values(seq_client.nextval,'benali','sami','20888999','sami@gmail.com','125');
insert into  client values(seq_client.nextval,'ryahi','monir','20777777','ryahi@gmail.com','126');
insert into  client values(seq_client.nextval,'gamour','rami','20001220','rami@gmail.com','127');


