
drop table tmp_osztaly;

create table tmp_OSZTALY (
       ID          NUMBER GENERATED ALWAYS AS IDENTITY,
       NEV         varchar2(50)
);

INSERT INTO tmp_osztaly (NEV)  VALUES ('1A'); 
COMMIT;

INSERT INTO tmp_osztaly (NEV)  VALUES ('1B'); 
COMMIT;

drop table tmp_tanulo;

create table tmp_tanulo (
       ID          NUMBER GENERATED ALWAYS AS IDENTITY,
       NEV         varchar2(50),
       SZUL_DATUM  date,
       IRSZ        varchar2(4),
       TELEPULES   varchar2(50),
       UTCA        varchar2(100),
       OSZTALY_ID  int
);

INSERT INTO tmp_tanulo (NEV,SZUL_DATUM,IRSZ,TELEPULES,UTCA,OSZTALY_ID) 
       VALUES ('Kiss Gizella', to_date('20110113','YYYYMMDD'), '1055','Budapest','Alma utca 3.',1 );
COMMIT;

INSERT INTO tmp_tanulo (NEV,SZUL_DATUM,IRSZ,TELEPULES,UTCA,OSZTALY_ID) 
       VALUES ('Nagy Ákos', to_date('20110225','YYYYMMDD'), '1051','Budapest','Piros utca 11.',1 );
COMMIT;

INSERT INTO tmp_tanulo (NEV,SZUL_DATUM,IRSZ,TELEPULES,UTCA,OSZTALY_ID) 
       VALUES ('Szabó Elvira', to_date('20101224','YYYYMMDD'), '2000','Szentendre','Iskola utca 4.',1 );
COMMIT;

INSERT INTO tmp_tanulo (NEV,SZUL_DATUM,IRSZ,TELEPULES,UTCA,OSZTALY_ID) 
       VALUES ('Takács Marcell', to_date('20110301','YYYYMMDD'), '1066','Budapest','Kõ utca 5.',2 );
COMMIT;

INSERT INTO tmp_tanulo (NEV,SZUL_DATUM,IRSZ,TELEPULES,UTCA,OSZTALY_ID) 
       VALUES ('Hajnal Erzsébet', to_date('20101123','YYYYMMDD'), '2000','Szentendre','Király utca 45.',2 );
COMMIT;

drop table tmp_tanar;

create table tmp_tanar (
       ID          NUMBER GENERATED ALWAYS AS IDENTITY,
       NEV         varchar2(50)
);

INSERT INTO tmp_tanar (NEV)  VALUES ('Bíró Ibolya'); 
COMMIT;

INSERT INTO tmp_tanar (NEV)  VALUES ('Füvessy Zsuzsanna'); 
COMMIT;

INSERT INTO tmp_tanar (NEV)  VALUES ('Gara Panni'); 
COMMIT;

INSERT INTO tmp_tanar (NEV)  VALUES ('Horváth Mária'); 
COMMIT;

INSERT INTO tmp_tanar (NEV)  VALUES ('Varga Balázs'); 
COMMIT;

INSERT INTO tmp_tanar (NEV)  VALUES ('Kádár Sándor'); 
COMMIT;

INSERT INTO tmp_tanar (NEV)  VALUES ('Doba László'); 
COMMIT;


drop table tmp_tantargy;

create table tmp_tantargy (
       ID          NUMBER GENERATED ALWAYS AS IDENTITY,
       TANTARGY    varchar2(50)
);

INSERT INTO tmp_tantargy (TANTARGY)  VALUES ('Matematika'); 
COMMIT;

INSERT INTO tmp_tantargy (TANTARGY)  VALUES ('Magyar'); 
COMMIT;

INSERT INTO tmp_tantargy (TANTARGY)  VALUES ('Történelem'); 
COMMIT;

INSERT INTO tmp_tantargy (TANTARGY)  VALUES ('Testnevelés'); 
COMMIT;

INSERT INTO tmp_tantargy (TANTARGY)  VALUES ('Fizika'); 
COMMIT;

INSERT INTO tmp_tantargy (TANTARGY)  VALUES ('Földrajz'); 
COMMIT;

INSERT INTO tmp_tantargy (TANTARGY)  VALUES ('Biológia'); 
COMMIT;

INSERT INTO tmp_tantargy (TANTARGY)  VALUES ('Angol'); 
COMMIT;

drop table tmp_tanar_vegzettseg;

create table tmp_tanar_vegzettseg(
       TANAR_ID           int,
       TANTARGY_ID        int
);


INSERT INTO tmp_tanar_vegzettseg VALUES (1,3); 
COMMIT;

INSERT INTO tmp_tanar_vegzettseg VALUES (2,6); 
COMMIT;

INSERT INTO tmp_tanar_vegzettseg VALUES (2,8); 
COMMIT;

INSERT INTO tmp_tanar_vegzettseg VALUES (3,1); 
COMMIT;

INSERT INTO tmp_tanar_vegzettseg VALUES (4,6); 
COMMIT;

INSERT INTO tmp_tanar_vegzettseg VALUES (4,7); 
COMMIT;

INSERT INTO tmp_tanar_vegzettseg VALUES (5,1); 
COMMIT;

INSERT INTO tmp_tanar_vegzettseg VALUES (5,5); 
COMMIT;

INSERT INTO tmp_tanar_vegzettseg VALUES (6,4); 
COMMIT;

INSERT INTO tmp_tanar_vegzettseg VALUES (6,1); 
COMMIT;

INSERT INTO tmp_tanar_vegzettseg VALUES (6,5); 
COMMIT;

INSERT INTO tmp_tanar_vegzettseg VALUES (7,7); 
COMMIT;

INSERT INTO tmp_tanar_vegzettseg VALUES (7,2); 
COMMIT;

drop table tmp_jegy;

create table tmp_jegy(
       IDOPONT          date,
       TANULO_ID        int,
       TANAR_ID         int,
       TANTARGY_ID      int,
       ERTEK            int
);

-- történelem - Biró Ibolya
INSERT INTO tmp_jegy VALUES (to_date('20100923','YYYYMMDD'),1,1,3,5); 
COMMIT;
INSERT INTO tmp_jegy VALUES (to_date('20100923','YYYYMMDD'),2,1,3,4); 
COMMIT;
INSERT INTO tmp_jegy VALUES (to_date('20100923','YYYYMMDD'),3,1,3,5); 
COMMIT;
INSERT INTO tmp_jegy VALUES (to_date('20100923','YYYYMMDD'),4,1,3,5); 
COMMIT;
INSERT INTO tmp_jegy VALUES (to_date('20100923','YYYYMMDD'),5,1,3,4); 
COMMIT;

INSERT INTO tmp_jegy VALUES (to_date('20101022','YYYYMMDD'),1,1,3,2); 
COMMIT;
INSERT INTO tmp_jegy VALUES (to_date('20101022','YYYYMMDD'),2,1,3,4); 
COMMIT;

-- Földrajz

INSERT INTO tmp_jegy VALUES (to_date('20100927','YYYYMMDD'),1,2,6,5); 
COMMIT;
INSERT INTO tmp_jegy VALUES (to_date('20100911','YYYYMMDD'),2,2,6,4); 
COMMIT;
INSERT INTO tmp_jegy VALUES (to_date('20101116','YYYYMMDD'),3,2,6,1); 
COMMIT;
INSERT INTO tmp_jegy VALUES (to_date('20101201','YYYYMMDD'),4,2,6,5); 
COMMIT;
INSERT INTO tmp_jegy VALUES (to_date('20100923','YYYYMMDD'),5,2,6,2); 
COMMIT;

INSERT INTO tmp_jegy VALUES (to_date('20101222','YYYYMMDD'),1,4,6,1); 
COMMIT;
INSERT INTO tmp_jegy VALUES (to_date('20100912','YYYYMMDD'),4,4,6,4); 
COMMIT;

-- Angol

INSERT INTO tmp_jegy VALUES (to_date('20100911','YYYYMMDD'),1,2,8,1); 
COMMIT;

INSERT INTO tmp_jegy VALUES (to_date('20101011','YYYYMMDD'),4,2,8,3); 
COMMIT;

INSERT INTO tmp_jegy VALUES (to_date('20101011','YYYYMMDD'),5,2,8,5); 
COMMIT;

-- Biológia

-- Horváth

INSERT INTO tmp_jegy VALUES (to_date('20101013','YYYYMMDD'),3,4,7,5); 
COMMIT;

INSERT INTO tmp_jegy VALUES (to_date('20101022','YYYYMMDD'),3,4,7,1); 
COMMIT;

INSERT INTO tmp_jegy VALUES (to_date('20101201','YYYYMMDD'),3,4,7,5); 
COMMIT;

INSERT INTO tmp_jegy VALUES (to_date('20101013','YYYYMMDD'),1,4,7,5); 
COMMIT;

INSERT INTO tmp_jegy VALUES (to_date('20101031','YYYYMMDD'),2,4,7,4); 
COMMIT;

-- Doba

INSERT INTO tmp_jegy VALUES (to_date('20101101','YYYYMMDD'),4,7,7,5); 
COMMIT;

INSERT INTO tmp_jegy VALUES (to_date('20101111','YYYYMMDD'),5,7,7,5); 
COMMIT;

INSERT INTO tmp_jegy VALUES (to_date('20101121','YYYYMMDD'),4,7,7,5); 
COMMIT;

-- Magyar

INSERT INTO tmp_jegy VALUES (to_date('20101106','YYYYMMDD'),1,7,2,5); 
COMMIT;

INSERT INTO tmp_jegy VALUES (to_date('20101107','YYYYMMDD'),2,7,2,5); 
COMMIT;

INSERT INTO tmp_jegy VALUES (to_date('20101110','YYYYMMDD'),3,7,2,5); 
COMMIT;

INSERT INTO tmp_jegy VALUES (to_date('20101012','YYYYMMDD'),4,7,2,4); 
COMMIT;

INSERT INTO tmp_jegy VALUES (to_date('20101206','YYYYMMDD'),5,7,2,5); 
COMMIT;

INSERT INTO tmp_jegy VALUES (to_date('20100906','YYYYMMDD'),1,7,2,5); 
COMMIT;

-- Testnevelés

INSERT INTO tmp_jegy VALUES (to_date('20101116','YYYYMMDD'),1,6,4,5); 
COMMIT;

INSERT INTO tmp_jegy VALUES (to_date('20101117','YYYYMMDD'),2,6,4,3); 
COMMIT;

INSERT INTO tmp_jegy VALUES (to_date('20101001','YYYYMMDD'),3,6,4,4); 
COMMIT;

INSERT INTO tmp_jegy VALUES (to_date('20101010','YYYYMMDD'),4,6,4,4); 
COMMIT;

INSERT INTO tmp_jegy VALUES (to_date('20101210','YYYYMMDD'),5,6,4,2); 
COMMIT;

INSERT INTO tmp_jegy VALUES (to_date('20100930','YYYYMMDD'),1,6,4,1); 
COMMIT;

-- Matematika

-- Kádár

INSERT INTO tmp_jegy VALUES (to_date('20101106','YYYYMMDD'),5,6,1,5); 
COMMIT;

INSERT INTO tmp_jegy VALUES (to_date('20101111','YYYYMMDD'),4,6,1,4); 
COMMIT;

INSERT INTO tmp_jegy VALUES (to_date('20101010','YYYYMMDD'),5,6,1,3); 
COMMIT;

INSERT INTO tmp_jegy VALUES (to_date('20100923','YYYYMMDD'),4,6,1,3); 
COMMIT;

INSERT INTO tmp_jegy VALUES (to_date('20101216','YYYYMMDD'),4,6,1,1); 
COMMIT;

INSERT INTO tmp_jegy VALUES (to_date('20101206','YYYYMMDD'),4,6,1,5); 
COMMIT;

INSERT INTO tmp_jegy VALUES (to_date('20101001','YYYYMMDD'),5,6,1,5); 
COMMIT;

-- Gara Panni

INSERT INTO tmp_jegy VALUES (to_date('20101020','YYYYMMDD'),3,3,1,5); 
COMMIT;

INSERT INTO tmp_jegy VALUES (to_date('20101026','YYYYMMDD'),2,3,1,2); 
COMMIT;

INSERT INTO tmp_jegy VALUES (to_date('20101020','YYYYMMDD'),1,3,1,4); 
COMMIT;

INSERT INTO tmp_jegy VALUES (to_date('20101216','YYYYMMDD'),1,3,1,4); 
COMMIT;

-- Varga Balázs

INSERT INTO tmp_jegy VALUES (to_date('20101201','YYYYMMDD'),1,5,1,2); 
COMMIT;

-- Fizika

-- Varga Balázs

INSERT INTO tmp_jegy VALUES (to_date('20101101','YYYYMMDD'),1,5,5,4); 
COMMIT;

INSERT INTO tmp_jegy VALUES (to_date('20101204','YYYYMMDD'),2,5,5,1); 
COMMIT;

INSERT INTO tmp_jegy VALUES (to_date('20101021','YYYYMMDD'),1,5,5,5); 
COMMIT;

INSERT INTO tmp_jegy VALUES (to_date('20101203','YYYYMMDD'),3,5,5,5); 
COMMIT;

INSERT INTO tmp_jegy VALUES (to_date('20101111','YYYYMMDD'),2,5,5,5); 
COMMIT;

INSERT INTO tmp_jegy VALUES (to_date('20100909','YYYYMMDD'),3,5,5,5); 
COMMIT;

-- 

INSERT INTO tmp_jegy VALUES (to_date('20100909','YYYYMMDD'),4,6,5,4); 
COMMIT;

INSERT INTO tmp_jegy VALUES (to_date('20101010','YYYYMMDD'),5,6,5,5); 
COMMIT;

INSERT INTO tmp_jegy VALUES (to_date('20101211','YYYYMMDD'),5,6,5,5); 
COMMIT;

INSERT INTO tmp_jegy VALUES (to_date('20101108','YYYYMMDD'),4,6,5,5); 
COMMIT;

INSERT INTO tmp_jegy VALUES (to_date('20101029','YYYYMMDD'),4,6,5,5); 
COMMIT;

INSERT INTO tmp_jegy VALUES (to_date('20101222','YYYYMMDD'),5,6,5,3); 
COMMIT;

select * from tmp_tanulo;
select * from tmp_osztaly;
select * from tmp_tanar;
select * from tmp_tantargy;
select * from tmp_tanar_vegzettseg;
select * from tmp_jegy;


/*
select * from tmp_tanulo;

select t.id, t.nev, g.id, g.tantargy from tmp_tanar t
join tmp_tanar_vegzettseg v on t.id=v.tanar_id
join tmp_tantargy g on v.tantargy_id=g.id;
*/
