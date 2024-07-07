--1. oldal

-- Kik járnal ebbe az iskolába? Hányan? -- 1
select * from tmp_tanulo;

-- Hányan?
select count(*) from tmp_tanulo;
-- Ki a legfiatalabb?
select * from tmp_tanulo
order by szul_datum;

-- Hány tanár tanit az iskolában?
select * from tmp_tanar;
select count(*) from tmp_tanar;

-- Rendezzük névsorba (csak a nevet jelenítsük meg)
select t.nev from tmp_tanar t order by t.nev;

-- 3. oldal

-- Milyen tantárgyakat tanitanak az iskolába?
select * from tmp_tantargy;

-- Tanítanak-e kémiát?
select * from tmp_tantargy t where t.tantargy='Kémia';

-- 4. oldal
-- Ki milyen tárgyat tanít?
select t.nev, tv.tantargy_id from tmp_tanar t
left join tmp_tanar_vegzettseg tv on t.id=tv.tanar_id;

select t.nev, ta.tantargy from tmp_tanar t
left join tmp_tanar_vegzettseg tv on t.id=tv.tanar_id
left join tmp_tantargy ta on ta.id=tv.tantargy_id;


--
select t.telepules, count(*) from tmp_tanulo t
group by t.telepules;



-- osztályoknak milyen tantárgyakat tanitanak?
select distinct o.nev, a.tantargy from tmp_tanulo t
join tmp_jegy j on t.id=j.tanulo_id
left join tmp_tantargy a on j.tantargy_id=a.id
join tmp_osztaly o on t.osztaly_id=o.id
order by o.nev, a.tantargy;


 Kik az oszályok tanárai?
 select distinct o.nev, a.nev from tmp_tanulo t
join tmp_jegy j on t.id=j.tanulo_id
left join tmp_tanar a on j.tanar_id=a.id
join tmp_osztaly o on t.osztaly_id=o.id
order by o.nev, a.nev;
 

 /*select * from tmp_tanulo;
select * from tmp_osztaly;
select * from tmp_tanar;
select * from tmp_tantargy;
select * from tmp_tanar_vegzettseg;
select * from tmp_jegy; */

-- Tanulónak hány jegyük van?
select s.nev, count(*) darab from (select t.nev, j.idopont, j.ertek from tmp_tanulo t
join tmp_jegy j on t.id=j.tanulo_id
order by 2,1 ) s
group by nev;


 
-- Hány tanár dolgozik az iskolában?

select count(*) from tmp_tanar t;

select count(*) from 
(select distinct t.id from tmp_tanar t
join tmp_jegy j on t.id=j.tanar_id ) s; 


-- hány jegyet adtak a tanárok?

select ta.nev, count(*) from tmp_jegy t
left join tmp_tanar ta on ta.id=t.tanar_id
group by ta.nev;

-- ki a legszigorúbb, ki a legengedékenyebb?
select ta.nev, cast(avg(t.ertek) as decimal(9,2)) atlag 
from tmp_jegy t
left join tmp_tanar ta on ta.id=t.tanar_id
group by ta.nev;

CREATE INDEX idx1_tmp_tanulo ON tmp_tanulo(ID);
CREATE INDEX idx1_tmp_tanar ON tmp_tanar(ID);

/

-- Ciklusok, dinamikus sql fogalma

DECLARE
sql_stmt VARCHAR2(2000);
BEGIN
  FOR rec IN 
  (
     select t.nev from tmp_tanulo t
  ) LOOP
    sql_stmt :=
    ' select t.nev, j.idopont, j.ertek from tmp_tanulo t ' ||
    ' join tmp_jegy j on t.id=j.tanulo_id ' ||
    ' order by 2,1' 
   
  --  dbms_output.put_line(sql_stmt);
    EXECUTE IMMEDIATE sql_stmt; 
    COMMIT;
    
  END LOOP;
  COMMIT;
  
END;
/
