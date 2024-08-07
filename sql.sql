
--	SQL server man. studio, saját adatbázisra belépni, new database diagram, 
--  2 tábla létrehozása, köztük külső kulcs kényszer
--	a kényszer attribútumai: no action, cascade, set null, set default. 
--  Programozott törlés, vagy logikai törlés (ha nem a helyhiány miatt van)
--	felhasználóváltás: abdiak, pubs_access adatbázis
--	SQL alapok: 1970-böl legutóbbi szabványai: 2006, 2008, 2011
--	DML: select, insert, DDL: create, alter, DCL: data control language, grant, revoke (TCL: transaction control language, pl. commit)

--  pubs_access adatbázis megnyitása, abdiak felhasználó

--SQL: WHERE
--a New York-i székhelyű kiadók neve
select [Company Name] from publishers where city='New York'

--#1 ÖNÁLLÓ FELADAT: 'A'-val kezdődő nevű szerzők születési éve

--AGGREGÁLT FÜGGVÉNY
--a legnaqyobb születési év
select max([year born]) from authors

--#2 ÖNÁLLÓ FELADAT: a legrégebbi kiadási dátum

--AL-LEKÉRDEZÉS
-- a legfiatalabb szerzo neve
select * from authors
where [year born] = (select max([year born]) from authors)

--#3 ÖNÁLLÓ FELADAT: a legrégebben kiadott könyv címe

--KÉT TÁBLA ÖSSZEFŰZÉSE
--New Yorkban kiadott könyvek címe
select t.title, [Company Name], city, p.pubid
from publishers p inner join titles t on p.pubid=t.pubid
where city='New York'

--#4 ÖNÁLLÓ FELADAT: 1991-ben kiadott könyvek kiadói

--TÖBB TÁBLA ÖSSZEFŰZÉSE
--Bramer, Susan által is írt, New Yorkban kiadott könyvek címe
select distinct t.title, [Company Name], city, p.pubid
from publishers p inner join titles t on p.pubid=t.pubid
inner join titleauthor ta on ta.isbn=t.isbn
inner join authors a on ta.au_id=a.au_id
where city='New York' and a.author like 'Bramer%'

--ugyanez máshogy
select t.title, [Company Name], city, p.pubid --ha itt nem lenne p alias, hiba lenne
from publishers p inner join titles t on p.pubid=t.pubid
where city='New York' and t.isbn in
    (select isbn
    from titleauthor ta inner join authors a on ta.au_id=a.au_id
    where a.author like 'Bramer%')

-- NORTHWIND ADATBÁZISRA ÁTÁLLÁS

--#5 ÖNÁLLÓ FELADAT: 2001 előtt intézett rendelések ügynökei (Lastname)
--#6 ÖNÁLLÓ FELADAT: Fuller nevű üzletkötő által eladott termékek neve (4 tábla)

--KÜLSŐ JOIN
--melyik kiadónak nem jelent meg könyve?
select * --, [Company Name], city, p.pubid
from publishers p left outer join titles t on p.pubid=t.pubid
where t.isbn is null
order by p.pubid

--#7 ÖNÁLLÓ FELADAT: melyik termék nem szerepel egy rendelésen sem

--CSOPORTOSÍTÁS
--ki hany uzletet kotott?
select e.lastname, count(orderid) as rend_szama
--count(*) kihozott volna Lamernek is egy rendelést
from employees e left outer join orders o on --hogy Lamer is szerepeljen
--from employees e inner join orders o on
e.employeeid = o.employeeid
group by e.employeeid, e.lastname
order by count(*) desc

--#8 ÖNÁLLÓ FELADAT: melyik kiadónak hány könyve jelent meg eddig

--ki nem kötött még üzletet?
select e.*
from employees e left outer join orders o on
e.employeeid = o.employeeid
where o.orderid is null

--TÖBBSZÖRÖS ALIAS
--ki kinek a fonöke? (Northwind) (3 szintig)
select dolg.lastname as dolg_neve, fonok.lastname as fonok_neve,
nagyfonok.lastname as nagyfonok_neve
from employees dolg left outer join employees fonok
on dolg.reportsto=fonok.employeeid
left outer join employees nagyfonok
on fonok.reportsto=nagyfonok.employeeid

--ÉRDEKESSÉG (KIEGÉSZÍTŐ ANYAG)
--a fenti problémára van jobb megoldás
--rekurzív lekérdezések (CTE, Common Table Expressions) használatával
--szintaxis: WITH...SELECT
WITH cte
AS (
    SELECT -- horgony
        1 AS n
   UNION ALL
   SELECT -- rekurzív tag
        n + 1
   FROM
        cte  --referencia a horgonyra
   WHERE
         -- terminátor
        n < 50)
SELECT * FROM cte --kiírja a számokat 1..50-ig

--ugyanez az Employees táblára: listázzuk ki, ki milyen szintu vezeto!
select * from employees;
with ki_a_beo (fonok_id, beo_id, nev, szint)
as
(
-- horgony: a Nagyfőnök
    select reportsto as fonok_id, EmployeeID as beo_id, lastname as nev, 0 as szint
    from Employees where reportsto is null

    union all

-- rekurzív tag
    select reportsto as fonok_id, EmployeeID as beo_id, lastname as nev, szint+1
    from employees e inner join ki_a_beo k on e.reportsto = k.beo_id
)
-- futtatás
select * from ki_a_beo
go

--ARITMETIKA, SZÁM-FORMÁZÁS
--megrendelések foösszege, melyik a legértékesebb rendelés?
--a számok a végrehajtás sorrendjét mutatják
4. select o.orderid as rend_szama,
    cast(o.orderdate as varchar(50)) as rend_datuma,
    str(sum((1-discount)*unitprice*quantity), 15, 2) as rend_osszege,
    sum(quantity) as darabok_szama,
    count(d.orderid) as tetelek_szama
1. from orders o inner join [order details] d on o.orderid=d.orderid
2. where...
3. group by o.orderid, o.orderdate
--order by o.orderdate
5. order by sum((1-discount)*unitprice*quantity) desc

--ido szerinti rendezéskor: group by o.orderid, o.orderdate

--HAVING, COUNT DISTINCT
--melyik ügynök hozta a legtöbb pénzt? Hány rendelésbol?
select  u.titleofcourtesy+' '+u.lastname+' '+ u.firstname +' ('+u.title +')'  as nev,
--select u.lastname as nev,
str(sum((1-discount)*unitprice*quantity), 15, 2) as behozott_penz,
count(distinct o.orderid) as rendelesek_szama, count(productid) as tetelek_szama
from orders o inner join [order details] d on o.orderid=d.orderid
    inner join employees u on u.employeeid=o.employeeid
group by u.employeeid, u.titleofcourtesy, u.title, u.lastname, u.firstname
--megfigyelni: emp.id szerint is kell group, bár nem érdekel minket, mert
--lehetnek azonos nevu ügynökök
having count(distinct o.orderid)>50 --ha csak az 50-nél több megrendelésu ügynökök érdekelnek
order by behozott_penz desc

--inner join miatt csak 9 ügynökünk van

--#9 ÖNÁLLÓ FELADAT: melyik termékkategória (Categories) bonyolította le a 2000-es évben a legnagyobb forgalmat? Hány termékkel?

--ISNULL
--az ügynöklista alján 0-val szerepeljenek azok is, akikhez nincs rendelés
select  isnull(u.titleofcourtesy, '')+' '+isnull(u.lastname, '')+' '+ isnull(u.firstname, '') +' ('+isnull(u.title, '') +')'  as nev,
isnull(str(sum((1-discount)*unitprice*quantity), 15, 2), 'N/A') as behozott_penz,
count(distinct o.orderid) as rendelesek_szama, COUNT(d.productid) as tetelek_szama
from employees u left outer join
    (orders o inner join [order details] d on o.orderid=d.orderid)
on u.employeeid=o.employeeid
--where u.titleofcourtesy='Mr.' --ha csak a férfiak érdekelnek
group by u.employeeid, u.titleofcourtesy, u.title, u.lastname, u.firstname
order by sum((1-discount)*unitprice*quantity) desc

--TOP 1
--melyik a legkeresettebb termék?
select top 1 p.productid, p.productname, count(*) as hanyszor_szerepel,
    sum(quantity) as ossz_darabszam
from products p left outer join [order details] d on p.productid=d.productid
group by p.productid, p.productname
order by hanyszor_szerepel desc --AZ EREDMÉNY: 59

--#10 ÖNÁLLÓ FELADAT: melyik a legtöbb könyvvel rendelkező kiadó?

--ÖSSZETETT LEKÉRDEZÉS
--melyik ügynök adta el a legtöbbet a legkeresettebb termékbol?
--elso valtozat
 select top 1 u.titleofcourtesy+' '+u.lastname+' '+ u.firstname +' ('+u.title +')'  as nev,
    sum(quantity) as hanyat_adott_el
 from orders o inner join [order details] d on o.orderid=d.orderid
    inner join employees u on u.employeeid=o.employeeid
 where d.productid = 59 --már tudjuk, hogy ez a nyero termék
 group by u.employeeid, u.titleofcourtesy, u.title, u.lastname, u.firstname
 order by sum(quantity) desc

/************************************************************************
#11 ÖNÁLLÓ FELADAT

Melyik ügynök adta el a legtöbbet a legkeresettebb termékbol és mi az a termék?

**************************************************************************/
/**************************************************************************
#12 ÖNÁLLÓ FELADAT

A legtermékenyebb szerzo melyik kiadónál publikált legtöbbször?
**************************************************************************/

--DATETIME FÜGGVÉNYEK
select 2+3
select getdate() --datetime adattípus
select DATEDIFF(s,'2013-10-10 12:13:50.370', '2013-10-10 14:16:50.370')
select DATEADD(s, 1000, '2013-10-10 14:16:50.370')
select YEAR(getdate()), MONTH(getdate())

--TÖBB SZINTŰ CSOPORTOSÍTÁS
--az üzletek száma üzletkötőnként és havonta
select e.employeeid, lastname, year(orderdate) as ev, month(orderdate) as honap, 
count(orderid) as rend_szam
from employees e left outer join orders o on e.employeeid=o.employeeid
group by e.employeeid, lastname, year(orderdate), month(orderdate)
order by lastname, ev, honap

--SZEBBEN:
select e.employeeid, lastname, 
cast(year(orderdate) as varchar(4)) +'_'+  cast(month(orderdate) as char(2)) as honap, count(orderid) as rend_szam
from employees e left outer join orders o on e.employeeid=o.employeeid
group by e.employeeid, lastname, cast(year(orderdate) as varchar(4)) +'_'+  cast(month(orderdate) as char(2))
order by lastname, honap

--#13 ÖNÁLLÓ FELADAT: a megjelent könyvek száma kiadónként és évente 

--SELECT CASE
--u.ez kozmetikázva
select e.employeeid, lastname,
case
    when month(orderdate) < 10 then cast(year(orderdate) as varchar(4)) +'_0'+  cast(month(orderdate) as char(2))
    when month(orderdate) >= 10 then cast(year(orderdate) as varchar(4)) +'_'+  cast(month(orderdate) as char(2))
    else 'N.A'
end as honap,
count(orderid) as rend_szam
from employees e left outer join orders o on e.employeeid=o.employeeid
group by e.employeeid, lastname,
case
    when month(orderdate) < 10 then cast(year(orderdate) as varchar(4)) +'_0'+  cast(month(orderdate) as char(2))
    when month(orderdate) >= 10 then cast(year(orderdate) as varchar(4)) +'_'+  cast(month(orderdate) as char(2))
    else 'N.A'
end --ezt meg kellett ismételnünk, szebb lett volna erre saját függvényt írni
order by lastname, honap

--TÁBLA LÉTREHOZÁSA LEKÉRDEZÉSSEL
--a havonta átlagosan kötött üzletek száma üzletkötőnként, ki a legjobb?
--a kétszintű aggeregáció: AVG(COUNT()) nem működik
--példák:
select GETDATE() as ido into uj_tabla
select * from uj_tabla
drop table uj_tabla
select * into uj_tabla from employees

--ELSŐ megoldás: ideiglenes táblával
--drop table #tt
select e.employeeid, lastname, year(orderdate) as ev, month(orderdate) as honap, count(orderid) as rend_szam
into #tt
from employees e left outer join orders o on e.employeeid=o.employeeid
group by e.employeeid, lastname, year(orderdate), month(orderdate) 
order by lastname, honap

select * from #tt
--Warning: Null value is eliminated by an aggregate or other SET operation.
--Ok: an aggregate function(max,sum,avg..) exists on null values (kikapcsolható)

select lastname, str(avg(cast(rend_szam as float)), 15, 2) as atlagos_rend_szam
--select lastname, avg(rend_szam) as atlagos_rend_szam
from #tt group by employeeid, lastname
order by atlagos_rend_szam desc

--TÁBLANÉV HELYETT TELJES LEKÉRDEZÉS
--MÁSODIK megoldás: egy (beágyazott) lekérdezéssel
select forras.lastname, str(avg(cast(forras.rend_szam as float)), 15, 2) as havi_atlagos_rend_szam
			--cast helyett egyszerűbb: alant nem count(orderid), hanem 1.0*count(orderid) álljon
from (
	select e.employeeid, lastname, year(orderdate) as ev, month(orderdate) as honap, count(orderid) as rend_szam
	from employees e left outer join orders o on e.employeeid=o.employeeid
	group by e.employeeid, lastname, year(orderdate), month(orderdate) 
) as forras --mindenképpen kell alias nevet adni
group by employeeid, lastname
order by havi_atlagos_rend_szam desc

--#14 ÖNÁLLÓ FELADAT: meyik kiadó hány könyvet ad ki évente átlagosan?

--SZORGALMI FELADATOK:
--melyik terméket hányszor rendelték meg havonta (átlagosan)?
--ki produkált legalább másfélszer akkora bevételt, mint a főnöke?

--TÍPUSFELADAT: KÉZZEL ÖSSZEÁLLÍTOTT KULCS
--ki, MELYIK HÓNAPBAN kötötte A LEGTÖBB RENDELÉST? pl. Buchanan 1998. febr.-ban
--tehát a csoportból egy konkrét rekordot kell kivenni egy mező maximális értékénél
--megoldás: a rekord azonosítása egy beágyazott lekérdezésben, utána erre szűrés
--itt célszerű a KÉZZEL ÖSSZEÁLLÍTOTT KULCS használata
--egy embernek lehet több rekordja is az eredményben!

--az előző #tt táblát használjuk
--ideiglenes tábla nélkül egy kicsit bonyolult lenne...
select * from #tt
select employeeid, lastname, ev, honap, rend_szam
from #tt
where cast(employeeid as varchar(10)) + cast(rend_szam as varchar(10)) in ( 
	--VEGYÜK ÉSZRE: A KÉT SOR KÖZÖTT CSAK A "MAX" A KÜLÖNBSÉG
	select cast(employeeid as varchar(10))+ cast(max(rend_szam) as varchar(10)) 
	from #tt  
	group by employeeid
)
order by rend_szam
--azért kell a beágyazott lekérdezés, mert különben az évet, hónapot nem tudnánk kivenni
--ha két hónap holtversenyben vezet, akkor egy név kétszer szerepel

--#15 ÖNÁLLÓ FELADAT: melyik kiadó melyik évben adta ki a legtöbb könyvet?

--MEZŐ-ORIENTÁLT ÉS ESEMÉNY-ORIENTÁLT ADATMODELL
--SAJÁT ADATBÁZIS MEGNYITÁSA
--rekord <-> mező átalakítás SQL UNION és CASE segítségével
--alkalmazás: esemény-orientált <-> hagyományos (mező-orientált) modell-átalakítás
--(ezt késobb kurzorokkal is megcsináljuk)

--Példa: 3 szüretelŐ brigád eredménye 5 nap alatt:
CREATE TABLE [dbo].[csapat] (
    [csapat_id] [int] NOT NULL ,
    [csapat_nev] [nvarchar] (50) NOT NULL
)

CREATE TABLE [dbo].[eredm_heti] (
    [csapat_id] [int] NOT NULL ,
    [e_hetfo] [int] NULL ,
    [e_kedd] [int] NULL ,
    [e_szerda] [int] NULL ,
    [e_csut] [int] NULL ,
    [e_pentek] [int] NULL
)

CREATE TABLE [dbo].[eredm_napi] (
    [csapat_id] [int] NOT NULL ,
    [nap_id] [int] NOT NULL ,
    [eredm] [int] NOT NULL
)

CREATE TABLE [dbo].[nap] (
    [nap_id] [int] NOT NULL ,
    [nap_nev] [nvarchar] (50) NOT NULL
)

go

--hozzuk létre a kulcs és külső kulcs kényszereket (diagram editorral)
--írjunk be 3 brigádot: Csontbrigád, Mániákusok, Pató Pál
--az eredm_heti táblába

select * from eredm_napi
select * from eredm_heti

--hogyan tudjuk ebbŐl feltölteni az eredm_napi táblát?
--így:

select csapat_id, 1 as nap_id, e_hetfo as eredm
from eredm_heti
union
select csapat_id, 2 as nap_id, e_kedd as eredm
from eredm_heti
union
select csapat_id, 3 as nap_id, e_szerda as eredm
from eredm_heti
union
select csapat_id, 4 as nap_id, e_csut as eredm
from eredm_heti
union
select csapat_id, 5 as nap_id, e_pentek as eredm
from eredm_heti
order by csapat_id, nap_id

GO

--írjuk be a lekérdezést az eredm_napi táblába

delete eredm_napi

insert eredm_napi
select csapat_id, 1 as nap_id, e_hetfo as eredm
from eredm_heti
union
select csapat_id, 2 as nap_id, e_kedd as eredm
from eredm_heti
union
select csapat_id, 3 as nap_id, e_szerda as eredm
from eredm_heti
union
select csapat_id, 4 as nap_id, e_csut as eredm
from eredm_heti
union
select csapat_id, 5 as nap_id, e_pentek as eredm
from eredm_heti
order by csapat_id, nap_id

select * from eredm_napi

--most ugyanez visszafelé: egy trükkös CASE és csoportosítás kombinációja

create view vi_napibol_heti as
select csapat_nev,
sum(case --SUM helyén lehetne AVG, MIN, MAX is, mert csak egy rekordot dolgoz fel
    when nap_id=1 then eredm
    else null
end)  as e_hetfo,
sum(case
    when nap_id=2 then eredm
    else null
end)  as e_kedd,
sum(case
    when nap_id=3 then eredm
    else null
end)  as e_szerda,
sum(case
    when nap_id=4 then eredm
    else null
end)  as e_csut,
sum(case
    when nap_id=5 then eredm
    else null
end)  as e_pentek
from eredm_napi en inner join csapat cs on cs.csapat_id=en.csapat_id
group by en.csapat_id, csapat_nev

--PIVOT/UNPIVOT használható ugyanerre:
EXEC sp_dbcmptlevel [saját adatbázis neve], 90
select csapat_id, b.[1] as e_hetfo, b.[2] as e_kedd, b.[3] as e_szerda, b.[4] as e_csut, b.[5] as e_pentek
from
	(select * from eredm_napi) as forras pivot 
		( sum(eredm) for nap_id in ( [1],[2],[3],[4],[5] )) as b
		--"forras": csak szintaktikai okokból kell
		--mivel itt is kézzel fel kell sorolni a lehetséges értékeket, ezért (sajnos) nem sokat segít
	
--#16 ÖNÁLLÓ FELADAT
--a northwind.employees táblát másoljuk át a saját adatbázisunkba
--"select ... into" módszerrrel
--írjunk egy lekérdezést, ami a mező-orientált alakból a rekord-orientált
--alakot állítja elő,
--az EmployeeID, Lastname, Address, City mezokre (union)!

--segítség: TÁVOLI TÁBLA VAGY MÁS OBJEKTUM ELÉRÉSE
select * into products from northwind.dbo.products
select * into customers from northwind.dbo.Customers
select top 1 * into orders from northwind.dbo.orders
select top 1 * into [order details] from northwind.dbo.[order details] --ha csak a séma kell


--            Gyakorlatok adatbázis-objektumokkal

--a stupido2000.mdb letöltése, vásárló, város, szállító-termék tábláinak importálása a saját adatbázisba
--http://vassanyi.ginf.hu/ab/stupido_2000.mdb
--adattípusok ellenőrzése
--kulcsok, külső kulcsok helyreállítása a diagramszerkesztővel
--kulcs, külső kulcs kényszerek ellenőrzése a tábla szerkesztésekor
--ennek tesztelése (hibát akarunk kiváltani)

--UPDATE, DELETE, INSERT SZINTAXISA, KIPRÓBÁLÁSA A SAJÁT ADATBÁZISBAN
update vásárló set egyenleg=0  where egyenleg<0
--check cnstraint (kényszer) elhelyezése az egyenleg mezőre (>=0) és a dátum mezőre (<getdate())

--új irszám mezo felvétele a vásárló táblába
alter table vásárló add irszám nvarchar(50)

update vásárló set irszám='ismeretlen'
select * from vásárló

--külön figyelmet érdemel az "UPDATE FROM" 
--egyik táblából a másikba átírni valamilyen
--információt
--az irszám kitöltése a Város táblából

update vásárló set irszám=vs.irszám
from vásárló v inner join város vs on v.városnév=vs.városnév
select * from vásárló

--INSERT

insert vásárló (vásárlónév, városnév, egyenleg)
values ('próba', 'Lukafa', 25)

--másolat készítése a Vásárló tábláról, eredeti törlése majd visszaállítása
--ideiglenes táblák haszna és használata, select ... into

select * into t2 from vásárló
delete vásárló
insert vásárló select * from t2

--a visszaállításkor mindenki egyenlege 0 legyen
--ehhez kell: konstans a select listában
--példa:
select vásárlónév, 5 as konstans , getdate() from vásárló

--tehát: a visszaállításkor mindenki egyenlege 0 legyen

delete vásárló
insert  vásárló select Vásárlónév, városnév, 0, null from t2
select * from vásárló

--"show execution plan" a Query -> display est. exec. plan a Bramer, Susan lekérdezésre
--    (melyik ügynök adta el a legtöbbet a legkeresettebb termékbol)
-- megfigyelni: a szurések a fa leveleinél vannak, hogy az adatszerkezetek kicsik legyenek


--            DDL
--create table gyakorlása

create table proba (id int not null, nev varchar(51))
insert proba values (5, 'név')
select * from proba

--view készítése: leghuségesebb vásárlónk kedvenc szállítója (kézzel)

create view vi_vasarlo as
select distinct vásárlónév + ' ' + városnév as vnev from vásárló


/**********************************************
--kitekintés: Geographic Information Systems
***********************************************/
--bevezető: a GIS szerepe (ppt)
--mondial script futtatása

USE mondial

select * from city where Longitude is not null and Latitude is not null --718
select * from city where Longitude is null or Latitude is null --2333

ALTER TABLE city ADD geog Geography
go
UPDATE city SET geog = Geography::Point(Latitude, Longitude, 4326) 
WHERE Longitude is not null and Latitude is not null
GO
--4326:
--The 4326 in the statement represents the spatial reference identifier (SRID). 
--The SRID corresponds to a spatial reference system based on the specific 
--ellipsoid used for either flat-earth mapping or round-earth mapping. 
--A spatial column can contain objects with different SRIDs. However, only spatial 
--instances with the same SRID can be used when performing operations 
--with SQL Server spatial data methods on your data. SQL Server uses the 
--default SRID of 4326, which maps to the WGS 84 spatial reference system.

--4326: a mértékegység méter	
 
ALTER TABLE island ADD geog Geography;
go
UPDATE island SET geog = Geography::Point(Latitude, Longitude, 4326) 
WHERE Longitude is not null and Latitude is not null
GO
 
ALTER TABLE mountain ADD geog Geography
go
UPDATE mountain SET geog = Geography::Point(Latitude, Longitude, 4326) 
WHERE Longitude is not null and Latitude is not null
GO

select * from mountain

--STdistance függvény.
SELECT c.Name, m.Name [Mountain Name], 
       c.geog.STDistance(m.geog)/1000 as [Distance in km]--, m.geog
FROM city c, mountain m
WHERE c.geog is not null
and c.Name = 'Portland'
ORDER BY c.geog.STDistance(m.geog)

--The following two examples show how to add and query geometry data. The first example creates a table with an 
--identity column and a geometry column GeomCol1. A third column renders the geometry column into its Open Geospatial 
--Consortium (OGC) Well-Known Text (WKT) representation, and uses the STAsText() method. Two rows are then inserted: one 
--row contains a LineString instance of geometry, and one row contains a Polygon instance.

IF OBJECT_ID ( 'dbo.SpatialTable', 'U' ) IS NOT NULL 
    DROP TABLE dbo.SpatialTable;
GO

CREATE TABLE SpatialTable 
    ( id int IDENTITY (1,1),
    GeomCol1 geometry, 
    GeomCol2 AS GeomCol1.STAsText() );  --computed column
GO

INSERT INTO SpatialTable (GeomCol1)
VALUES (geometry::STGeomFromText('LINESTRING (100 100, 20 180, 180 180)', 0));
--itt a 0 azért szerepel, mert nem geography, hanem geometry objektum lesz belőle
--(nem kell srid)
--linestring: pontjaival adott összefüggő vonal, lehet zárt és metszheti magát
INSERT INTO SpatialTable (GeomCol1)
VALUES (geometry::STGeomFromText('POLYGON ((0 0, 150 0, 150 150, 0 150, 0 0))', 0));
--polygon: soxög, a határvonala nem metszheti magát, de a belsejében lehetnek foltok, melyek nem tartoznak hozzá

GO
 
select * from SpatialTable
--az eredményt nézzük meg a Spatial results panelen is!

--The second example uses the STIntersection() method to return the points where the two previously inserted geometry instances intersect.
--ez az ábráról is látszik

DECLARE @geom1 geometry;
DECLARE @geom2 geometry;
DECLARE @result geometry;

SELECT @geom1 = GeomCol1 FROM SpatialTable WHERE id = 1;
SELECT @geom2 = GeomCol1 FROM SpatialTable WHERE id = 2;
SELECT @result = @geom1.STIntersection(@geom2);
select @result
SELECT @result.STAsText();
 
--hasonlóképpen a geography adattípusra:
IF OBJECT_ID ( 'dbo.SpatialTable', 'U' ) IS NOT NULL 
    DROP TABLE dbo.SpatialTable2;
GO

CREATE TABLE SpatialTable2
    ( id int IDENTITY (1,1),
    GeogCol1 geography, 
    GeogCol2 AS GeogCol1.STAsText() );
GO

INSERT INTO SpatialTable2 (GeogCol1)
VALUES (geography::STGeomFromText('LINESTRING(-122.360 47.656, -122.343 47.656)', 4326));

INSERT INTO SpatialTable2 (GeogCol1)
VALUES (geography::STGeomFromText('POLYGON((-122.358 47.653, -122.348 47.649, -122.348 47.658, -122.358 47.658, -122.358 47.653))', 4326));
GO
 
select * from SpatialTable2
--The second example uses the STIntersection() method to return the points where the two previously inserted geography instances intersect.
-- STIntersection

DECLARE @geog1 geography;
DECLARE @geog2 geography;
DECLARE @result geography;

SELECT @geog1 = GeogCol1 FROM SpatialTable2 WHERE id = 1;
SELECT @geog2 = GeogCol1 FROM SpatialTable2 WHERE id = 2;
SELECT @result = @geog1.STIntersection(@geog2);
select @result
SELECT @result.STAsText();
 
 --még egy geogr. példa:
DECLARE @g geography;
DECLARE @h geography;
SET @g = geography::STGeomFromText('LINESTRING(-122.360 47.656, -122.343 47.656)', 4326);
SET @h = geography::STGeomFromText('POINT(-122.34900 47.65100)', 4326);
SELECT @g.STDistance(@h);
 
 
/****************************************** 
 --az összes geography metódus:
 ******************************************
 
STArea (geography Data Type) 
STAsBinary (geography Data Type) 
STAsText (geography Data Type) 
STBuffer (geography Data Type) */
DECLARE @g geography;
SET @g = geography::STGeomFromText('LINESTRING(-122.360 47.656, -122.343 47.6956)', 4326);
SELECT @g.STBuffer(100), @g.STBuffer(100).ToString();
--STDimension (geography Data Type) 
DECLARE @temp table ([name] varchar(10), [geom] geography);
INSERT INTO @temp values ('Point', geography::STGeomFromText('POINT(-122.34900 47.65100)', 4326));
INSERT INTO @temp values ('LineString', geography::STGeomFromText('LINESTRING(-122.360 47.656, -122.343 47.656)', 4326));
INSERT INTO @temp values ('Polygon', geography::STGeomFromText('POLYGON((-122.358 47.653, -122.348 47.649, -122.348 47.658, -122.358 47.658, -122.358 47.653))', 4326));
SELECT [name], [geom].STDimension() as [dim] FROM @temp;
/*
STDisjoint (geography Data Type) 
STDistance (geography Data Type) 
STEndpoint (geography Data Type) 
STGeometryN (geography Data Type)	
*/
DECLARE @g geography;
SET @g = geography::STGeomFromText('MULTIPOINT(-122.360 47.656, -122.343 47.656)', 4326);
SELECT @g.STGeometryN(2).ToString(), @g.STNumGeometries();

--STGeometryType (geography Data Type)
--Point, LineString, Polygon, GeometryCollection, MultiPoint, MultiLineString, and MultiPolygon. 
STIntersection (geography Data Type) 
STIntersects (geography Data Type) 
STIsClosed (geography Data Type) 
STIsEmpty (geography Data Type) 
STLength (geography Data Type) 
STNumGeometries (geography Data Type) 
STNumPoints (geography Data Type) --hány pontból áll a görbe
STPointN (geography Data Type) --az n-edik pont
STSrid (geography Data Type) --4326
STStartPoint (geography Data Type) 
STUnion (geography Data Type) 
*/
DECLARE @g geography;
DECLARE @h geography;
SET @g = geography::STGeomFromText('POLYGON((-122.358 47.653, -122.348 47.649, -122.348 47.658, -122.358 47.658, -122.358 47.653))', 4326);
SET @h = geography::STGeomFromText('POLYGON((-122.351 47.656, -122.341 47.656, -122.341 47.661, -122.351 47.661, -122.351 47.656))', 4326);
select @g 
select @h
SELECT @g.STUnion(@h), @g.STUnion(@h).ToString();

/***************************************
geometry metódusok (nagyobb kínálat)
*****************************************
STArea (geometry Data Type) 
STAsBinary (geometry Data Type) 
STAsText (geometry Data Type) 
STBoundary (geometry Data Type) 
STBuffer (geometry Data Type) 
STCentroid (geometry Data Type) 
STContains (geometry Data Type) 
STConvexHull (geometry Data Type) 
STCrosses (geometry Data Type) 
STDifference (geometry Data Type) 
STDimension (geometry Data Type) 
STDisjoint (geometry Data Type) 
STDistance (geometry Data Type) 
STEndpoint (geometry Data Type) 
STEnvelope (geometry Data Type) 
STEquals (geometry Data Type) 
STExteriorRing (geometry Data Type) 
STGeometryN (geometry Data Type) 
STGeometryType (geometry Data Type) 
STInteriorRingN (geometry Data Type) 
STIntersection (geometry Data Type) 
STIntersects (geometry Data Type) 
STIsClosed (geometry Data Type) 
STIsEmpty (geometry Data Type) 
STIsRing (geometry Data Type) 
STIsSimple (geometry Data Type)--he nem metszi saját magát 
STIsValid (geometry Data Type) 
STLength (geometry Data Type) 
STNumGeometries (geometry Data Type) 
STNumInteriorRing (geometry Data Type) 
STNumPoints (geometry Data Type) 
STOverlaps (geometry Data Type) 
STPointN (geometry Data Type) 
STPointOnSurface (geometry Data Type) 
STRelate (geometry Data Type) 
STSrid (geometry Data Type) 
STStartPoint (geometry Data Type) 
STSymDifference (geometry Data Type) 
STTouches (geometry Data Type) 
STUnion (geometry Data Type) 
STWithin (geometry Data Type) 
STX (geometry Data Type) 
STY (geometry Data Type) 
*/


/***************************************
#17 ÖNÁLLÓ FELADAT: Melyek azok a fővárosok, melyek 1000 km sugarú környezetében nincs hegy?

1) keressük meg azokat a városokat, melyeknek 1000 km 
sugarú környezetében VAN hegy
2) ez alapján (al-lekérdezéssel) keressük meg azokat a városokat, melyeknek 1000 km 
sugarú környezetében NINCS hegy
3) és rajzoljuk ki ezen városok körüli 
1000km sugarú buffer területeket
4) a foltokba írjuk bele a város nevét! (select label column: nev
5) szűkítsük a találatokat a fővárosokra (a country táblából)!

--hetven ilyen főváros van
********************************************/

--további érdekességek: http://www.beginningspatial.com/beginning_spatial
--komolyabb GIS rendszer: http://qgis.org/


/*****************************************************************
--                T-SQL gyakorlatok
*****************************************************************/


--T-SQl változók: @i
--T-SQL vezérlési szerkezetek: if, while
--scriptek elemei (pl. print)

--pelda ciklusra: adjuk ossze a szamokat 1-tol n-ig
set nocount on
declare @i int, @eredm int
set @i=1
set @eredm=0
while @i<=23 begin
    set @eredm=@eredm+@i
    set @i=@i+1
end

select 'a számok összege: '+cast(@eredm as varchar(15))
print 'a számok összege: '+cast(@eredm as varchar(15))
select @eredm
select 'eredmény'
go
select rand()

--#18 ÖNÁLLÓ FELADAT a fenti script alapján: 
--1. egy uj tábla létrehozása, 2. 100 véletlen float értékkel feltöltése
--3. listázása és 4. törlése
--"generate SQL script" egy bonyolult Northwind táblára, külso kulccsal,indexekkel

--IF EXISTS példa: a táblát töröljük, ha már létezik
if exists (select * from dbo.sysobjects
        where id = object_id('[dbo].[veletlen]')
        and OBJECTPROPERTY(id, 'IsUserTable') = 1)
    drop table [dbo].[veletlen]

--@@IDENTITY: Az utolsó identtiy insert értéke lekérdezhető

-- PÉLDA ÜZLETI FOLYAMATRA: egy Northwind rendelést vigyünk végig!
--a szükséges táblák: products, customers, orders, order details
--1. ezekről készítsünk másolatot a saját adatbázisunkba
--2.
-- a.) termék kikeresése (keresés név alapján)
-- b.) kosár összeállítása (termék és mennyiség megadása) (a és b lépés összevonható lenne!)
-- c.) rendelés összértékének kiszámolása, jóváhagyás
--    (van-e rá fedezet, van-e elég raktáron?)
-- d.) raktárkészlet és ügyfél egyenleg módosítása
-- e.) státuszjelentés (a tranzakció sikeres vagy sem...)

-- a.) termék kikeresése:
declare @nev varchar(20), @statusz_leiras varchar(100);
declare @talalatok_szama int, @mennyiseg int;
declare @termekkod int, @statusz int;
declare @raktarkeszlet int, @ugyfel varchar(10);

set @nev = 'boston';
set @mennyiseg = 7;
set @ugyfel = 'arout';

-- ha egy terméket talál, akkor adja vissza a kulcsot
select @talalatok_szama = count(*) from products
        where productName like '%' + @nev + '%'    ;
if @talalatok_szama = 1
    begin
        select @termekkod = productID from products
            where productName like '%' + @nev + '%'
        set @statusz = 1;
        set @statusz_leiras = 'Egy találat: ' + cast(@termekkod as varchar(10));
    end
else
    begin
        set @statusz = 0;
        set @statusz_leiras = 'Több találat - szukítse a keresési feltételt!';
    end

-- b.) amig lehet, addig a KULCSokkal dolgozunk!
if @statusz = 1
    begin
        -- van-e raktáron? avagy, a rendelt mennyiség elérheto-e?
        select @raktarkeszlet = unitsInStock from products
            where productID = @termekkod

        if @raktarkeszlet >= @mennyiseg
            begin
                set @statusz = 2;
                set @statusz_leiras = @statusz_leiras + ' Van elég raktáron.';
            end

        else
            begin
                set @statusz_leiras = @statusz_leiras + ' Nincs elég raktáron.';
            end
end

-- ==================================
-- mennyibe kerül? Van elég pénze a vevönek?
-- ==================================
declare @egyenleg int, @osszeg money;
if @statusz = 2
    begin
        select @egyenleg = balance from customers where customerid = @ugyfel
        select @osszeg = unitPrice * @mennyiseg from products
            where productID = @termekkod
        if @egyenleg >= @osszeg
            begin
                set @statusz = 3  -- van rá pénz
                set @statusz_leiras = @statusz_leiras +
                ' Van rá fedezet.';
            end
        else
            begin
                set @statusz_leiras = @statusz_leiras +
                ' Nincs rá fedezet!';
            end
-----
-- eddig minden rendben: egy termék, van raktáron, van rá fedezet
if @statusz = 3
    begin
    -- új bejegyzés az Orders, Order Details táblákba
-- az OrderID automatikus sorszámozású,
-- új rekord beszúrása után vissza kell kérdeznünk az új értéket
-- és ezzel a kulcsértékkel kell az Order Details táblába bejegyezni
-- a rendelt terméket
        declare @rendelesszam int;
        insert into orders(customerID, orderdate)
			values (@ugyfel, getdate())

        set @rendelesszam = @@identity

        insert into [order details](orderid, productid, quantity)
        values(@rendelesszam, @termekkod, @mennyiseg);

        -- frissítés a Products.UnitsInStock, Customers.Balance mezok
        update products set unitsInStock = unitsInStock - @mennyiseg
	        where productid = @termekkod;
		update customers set balance = balance-@osszeg where customerid=@ugyfel
        set @statusz_leiras = @statusz_leiras + ' Sikeres vásárlás!'
    end
end
print @statusz_leiras;
--VÉGE

update products set unitsInStock = 900 where productid=40
update customers set balance=1000

--próbáljuk ki!
--futtatás után:
--"Cannot insert the value NULL into column 'Discount'"
--de a vásárló egyenlegét azért sikerült csökkenteni
--tanulság: ezt valahogy nem így kell csinálni!

-- További hiba: ha egyszerre több konkurens kérés érkezik, akkor
-- érdekes hibák léphetnek fel

-- megoldás: tranzakciókezelés (lásd késobb).

/*********************************************************
#19 ÖNÁLLÓ FELADAT:
Raktárkészlet-karbantartó script illetve tárolt eljárás

Az eljárást a raktáros használja arra, hogy egy
létezo termék raktárkészletét növelje, vagy egy új cikket vegyen fel
a raktárba.

bemenő paraméterek:
set @termeknev = 'Raclette'
set @mennyiseg = 12
set @szallito = 'Formago Company'

A script '%raclette%'-re illo terméknevet keres a Products táblában.
Ha több, mint 1 találat van, hibaüzenettel kilép.
Ha 1 találat van, akkor annak a raktárkészletét (unitsinstock) növeli
12-vel.
Ha nincs találat, akkor felvesz egy új Raclette nevu terméket, melynek a
szállítóját (supplier) a 3. paraméter alapján próbálja beállítani,
a fentihez hasonló logikával (több találat: hiba, 1 találat: megvan,
0 találat: új supplier felvétele)

A munkát a saját adatbázisban végezzük, eloször is (ha kell) másoljuk át ide a
két táblát!

1. lépés: olyan lekérdezés, amely visszaadja a mintára illeszkedo rekordok számát
2. lépés: beszúró INSERT illetve módosító UPDATE utasítás összerakása
3. lépés: a lekérdezések beágyazása egy IF feltételt használó script-be
4. lépés: a script tesztelése 
************************************************************/


/***************************************************************
--                TÁROLT ELJÁRÁSOK
****************************************************************/

drop procedure t2
create procedure t2
@i int
as
declare @j int
set @j=2
select * from northwind.dbo.employees where employeeid = @i+@j

go
--tesztelés:
t2 4

--PÉLDA: egyszeru üzleti folyamat tárolt eljárásként
--szállító-termék táblában megkeres egy terméket, ha pont egy találat van, akkor
--leszállítjuk az árát 15%-kal
--hibakódot ad vissza

drop procedure discount
go
create procedure discount
@termeknev varchar (50)
as
declare @talalat int, @hibakod varchar(50)
select @talalat=count(*) from [szállító-termék] where terméknév=@termeknev
if @talalat = 0  set @hibakod = 'nincs találat'
else if @talalat > 1  set @hibakod = 'túl sok találat'
else begin
    update [szállító-termék] set egységár = 0.85*egységár where terméknév=@termeknev
    set @hibakod = 'rendben'
end
print @hibakod  --select @hibakod -ot kipróbálni
go

exec discount 'gumimaci'

--ugyanez output paraméterrel

drop procedure discount_op
go
create procedure discount_op
@termeknev varchar (50),
@hibakod varchar(50) output
as
declare @talalat int
select @talalat=count(*) from [szállító-termék] where terméknév=@termeknev
if @talalat = 0  set @hibakod = 'nincs találat'
else if @talalat > 1  set @hibakod = 'túl sok találat'
else begin
    update [szállító-termék] set egységár = 0.85*egységár where terméknév=@termeknev
    set @hibakod = 'rendben'
end
go

declare @eredm varchar(50)
exec discount_op 'gumimaci', @hibakod=@eredm output
print @eredm

--#21 ÖNÁLLÓ FELADAT: ehhez hasonlóan a kapott nevű vásárló egyenlegének növelése 10%-kal
--a Vásárló táblában
--itt már tényleg elofordulhat, hogy egy névre több rekord is illik
--eljárás neve: bonus, paraméter a vásárlónév varchar(50)

--#22 ÖNÁLLÓ FELADAT: korábbi véletlen számos feladatunk megvalósítása tárolt eljárásként

create procedure sp_veletlen
@hany_szam int
as
declare @i int
--if exists: haladóknak
if exists (select * from dbo.sysobjects
        where id = object_id('[dbo].[veletlen]')
        and OBJECTPROPERTY(id, 'IsUserTable') = 1)
    drop table [dbo].[veletlen]

create table veletlen (szam float)
set @i=1
while @i<=@hany_szam begin
    insert veletlen (szam) values (100*rand())
    set @i=@i+1
end
select * from veletlen
drop table veletlen

go

exec sp_veletlen 250

--FELHASZNÁLÓI FÜGGVÉNYEK
--előző megoldásunk a forgalom havi bontására nem volt valami elegáns:
select e.employeeid, lastname,
case
    when month(orderdate) < 10 then cast(year(orderdate) as varchar(4)) +'_0'+  cast(month(orderdate) as char(2))
    when month(orderdate) >= 10 then cast(year(orderdate) as varchar(4)) +'_'+  cast(month(orderdate) as char(2))
    else 'N.A'
end as honap,
count(orderid) as rend_szam
from employees e left outer join orders o on e.employeeid=o.employeeid
group by e.employeeid, lastname,
case
    when month(orderdate) < 10 then cast(year(orderdate) as varchar(4)) +'_0'+  cast(month(orderdate) as char(2))
    when month(orderdate) >= 10 then cast(year(orderdate) as varchar(4)) +'_'+  cast(month(orderdate) as char(2))
    else 'N.A'
end
order by lastname, honap

--definialjunk ra felhasznaloi fuggvenyt!
drop function ev_honap
create function ev_honap (@datum datetime)
returns varchar(50) AS
begin
declare @eredm varchar(50)
set @eredm = case
    when month(@datum) < 10 then cast(year(@datum) as varchar(4)) +'_0'+  cast(month(@datum) as varchar(2))
    when month(@datum) >= 10 then cast(year(@datum) as varchar(4)) +'_'+  cast(month(@datum) as varchar(2))
    else 'N.A'
end
return @eredm
end

--így már szebb lesz:
use northwind
select e.employeeid, lastname, ab61.diak61.ev_honap(orderdate) as honap,
count(orderid) as rend_szam
from employees e left outer join orders o on e.employeeid=o.employeeid
group by e.employeeid, lastname, ab61.diak61.ev_honap(orderdate)
order by lastname, honap

/**************************************************************************

--#23 ÖNÁLLÓ FELADAT: 
--írjunk függvényt, amely két, datetime típusú változó közül
--visszaadja a korábbit, ha valamelyik null, akkor pedig a 'N.A.' stringet!
--tesztelés az orders táblán

****************************************************************************/

-- KURZOROK

-- a kurzor fogalma
-- szintaxis és egy egyszerû példa:

declare @emp_id int, @emp_name nvarchar(50), @i int, @address nvarchar(60),
    @city nvarchar(50)
declare cursor_emp cursor
    for
    select employeeid, lastname, address, city from employees

set @i=1
open cursor_emp
fetch next from cursor_emp into @emp_id, @emp_name, @address, @city
while @@fetch_status = 0
begin
    print cast(@i as varchar(5)) + '. ügynök:'
    print 'ID: ' + cast(@emp_id as varchar(5)) + ', Név: ' + @emp_name + + ', cím: ' + @address
    set @i=@i+1
    fetch next from cursor_emp into @emp_id, @emp_name, @address, @city
end
close cursor_emp
deallocate cursor_emp

--Másik példa kurzorra: a korábbi rekord-mezõ átalakítás (tranzakcionális alakra hozás)

use northwind
select * from employees
declare @emp_id int, @emp_name nvarchar(50), @i int, @address nvarchar(60),
    @city nvarchar(50)
create table #eredm (adatid int, dolg_id int,
        adatnev varchar(50), adatertek nvarchar(100))
declare cursor1 cursor
    for
    select employeeid as emp_id, firstname+' '+lastname as emp_name,address, city
    from employees

set @i=0
open cursor1
fetch next from cursor1 into @emp_id, @emp_name, @address, @city
while @@fetch_status = 0
begin
    --print @emp_id print @emp_name print @i
    if @emp_name is not null begin
        insert #eredm values(@i, @emp_id, 'dolgozo_neve', @emp_name)
        set @i=@i+1
    end
    if @address is not null begin
        insert #eredm values(@i, @emp_id, 'dolgozo_cime', @address)
        set @i=@i+1
    end
    if @city is not null  begin
        insert #eredm values(@i, @emp_id, 'dolgozo_varosa', @city)
        set @i=@i+1
    end
    fetch next from cursor1 into @emp_id, @emp_name, @address, @city

    print @emp_id
end
close cursor1
deallocate cursor1
print 'feldolgozás vége'
select * from #eredm
drop table #eredm
GO

/*************************************************************
#24 ÖNÁLLÓ FELADAT (könnyű)

olyan script, amely az amerikai vásárlók (customers tábla, country mező) rekordjain 
végiglépked és kiírja minden vásárló nevét, és hogy eddig hány rendelése volt
*/

/*************************************************************
#25 ÖNÁLLÓ FELADAT (NEHÉZ)

A feladat annak kiderítése, hogy a paraméterként kapott
ügynök

1) milyen átlagos gyakorisággal (napokban mérve) köt nagy értékű rendelést, illetve
2) hányszor fordult elo vele, hogy két kis értékű rendelése közvetlenül követte egymást

nagy értékűnek a 200 dollár feletti rendelések számítanak. Tehát ha pl. egy ügynök
rendeléseinek a dátumai az alábbiak:

2011. jan. 3. (820 $)
2011. jan. 4. (190 $)
2011. jan. 5. (11,200 $)
2011. jan. 10. (100 $)
2011. jan. 11. (140 $)
2011. jan. 20. (540 $)

akkor
1) 2+15=17 nap alatt 3 nagy értéku rendelés, tehát az átlag 5.7 nap
2) egyszer fordult elo, hogy egymás után két kisértéku rendelés jött

A megoldás lépései:

1. kurzor készítése az illetõ ügynök rendelési dátumaira és azok értékére
(korábbi anyagból kiollózható a lekérdezés), rendezés dátum szerint
2. a kurzor végigléptetése, a rendelés típusának mentése két rekord között egy változóba
3. tesztelés az Orders táblán

segítség:
select DATEDIFF(day, '2011-02-23', '2011-03-03') -- az eredmény 11, integer

Továbbfejlesztés (SZORGALMI FELADAT): legyen ez egy tárolt eljárásban, és hívjuk meg sorban minden ügynökre!
Vagy próbáljuk ugyanezt elvégezni két egymásba ágyazott kurzorral (a külső
az ügynökökön lépked végig, a belső az illető rendelésein)

**************************************************************************/

--                TRANZAKCIÓK

--batch (köteg) két GO utasítás között

--T-SQL változók csak a kötegen belül érvényesek
--egy script több köteget is tartalmazhat: ha valamelyikben hiba van, veszi a következot

--drop table pelda
create table pelda (szam int)
insert pelda values (44)
go

--1. kiserlet
update pelda set szam=22
go
selec * from pelda --szintaktikai hiba
go
select * from pelda
--eredmeny 22, mert az elso batch sikerult

--ugyanez egy batch-ben
delete pelda
insert pelda values (44)
go

--2. kiserlet
update pelda set szam=22
selec * from pelda --szintaktikai hiba
go
select * from pelda
--eredmeny 44
--mert szintaktikai hiba esetén az egész batchból semmi sem hajtódik végre

--DE!
--ha az objektumnev hianyzik (nem parse hiba), akkor nem szamit a batch:
delete pelda
insert pelda values (44)
go

--3. kiserlet
update pelda set szam=22
select * from plda --Invalid object name
go
select * from pelda
--eredmeny 22
go

--PEDIG MIND A KÉTSZER CSAK EGY BETŰT HAGYTUNK KI!

--ACID tulajdonságok: PPT-ről
--IZOLÁCIÓ DEMO
--implicit tranzakció

--drop table pelda2
--drop table pelda3
set nocount on
create table pelda2 (id int not null, szam int)
insert pelda2 values (0, 44)
insert pelda2 values (1, 44)
insert pelda2 values (2, 44)
create table pelda3 (id int not null, pelda2_id int)
insert pelda3 values (1, 1)
insert pelda3 values (2, 1)
--külso kulcs kényszer a ketto közé:
alter table pelda2 add constraint pk_1 primary key (id)
alter table pelda3 add constraint pk_2 primary key (id)
alter table pelda3 add constraint fk_1 foreign key  (pelda2_id)  references pelda2 (id)

go

delete pelda2 --ez annyi logikai törlés, ahány rekordja van
-- nem törli az 1. es 3. rekordot, mert a 2. törlésekor hiba volt!!
-- mindhárom rekord megvan:
go
select * from pelda2
go

--    HIBAKEZELÉS: try/catch
create table #log(time_stamp datetime, err_num int)
go
begin try
    delete pelda2
    --....
end try
begin catch
    SELECT
        ERROR_NUMBER() AS ErrorNumber,
        ERROR_SEVERITY() AS ErrorSeverity,
        ERROR_STATE() AS ErrorState,
        ERROR_PROCEDURE() AS ErrorProcedure,
        ERROR_LINE() AS ErrorLine,
        ERROR_MESSAGE() AS ErrorMessage
    insert #log (time_stamp, err_num) values (GETDATE(), ERROR_NUMBER())
end catch

--eredmény:
select * from #log

-- "igazi", azaz explicit tranzakciók

set xact_abort off
--begin tran, commit tran, rollback tran
begin tran
print @@trancount
--itt egy hiba:
delete from pelda2
--commit tran
--HIBA, ha elfelejtjük a commit-ot...
go
--ezután VIGYÁZAT:
print @@trancount
-- 1, tehát besült a tr. (igen nagy hiba lehet belole!!)
--megoldás kézzel:
rollback tran
print @@trancount
-- most már 0

go

--ehelyett használjuk az xact_abortot
set xact_abort on     --     " Specifies whether Microsoft SQL Server automatically rolls back the
            --    current transaction if a Transact-SQL statement raises a run-time error"
            --vagy minden insert, cast, update, delete stb. után a @@error vizsgálata
--go
begin tran
print 'eloször: ' + cast(@@trancount as varchar)
--itt egy hiba:
delete from pelda2
--ezért ide már nem jut el:
commit tran
go
                            --if @@trancount>0 rollback tran
--ezután:
print 'végül: ' + cast(@@trancount as varchar)
-- ez 0

--3 insert utasítással demonstráljuk a tr. rollback-ot, a hiba a 2.-nál legyen
set nocount on
--drop table t2
--drop table t1
go
CREATE TABLE t1 (a int PRIMARY KEY)
CREATE TABLE t2 (a int REFERENCES t1(a))
GO
INSERT INTO t1 VALUES (1)
INSERT INTO t1 VALUES (3)
INSERT INTO t1 VALUES (4)
INSERT INTO t1 VALUES (6)
GO
SET XACT_ABORT OFF
GO
BEGIN TRAN
delete t2
INSERT INTO t2 VALUES (1)
INSERT INTO t2 VALUES (2) --külső kulcs kényszer hiba
INSERT INTO t2 VALUES (3)
COMMIT TRAN
GO
print 'eloször: ' + cast(@@trancount as varchar) //trancount = 0, tehát commit-olt
/* Select shows only keys 1 and 3 added.
   Key 2 insert failed and was rolled back, but
   XACT_ABORT was OFF and rest of transaction
   succeeded.*/

--ugyanez történt volna begin/commit transaction nélkül is

select * from t2

SET XACT_ABORT ON
GO
delete t2
BEGIN TRAN
INSERT INTO t2 VALUES (4)
INSERT INTO t2 VALUES (5) /* Foreign key error */
INSERT INTO t2 VALUES (6)
COMMIT TRAN
GO
print 'végén: ' + cast(@@trancount as varchar)

/* Key 5 insert error with XACT_ABORT ON caused
   all of the second transaction to roll back. */

SELECT * FROM t2
GO

--tranzakcio izolációs szintek demonstrációja
create table termek(id int primary key, eladva varchar(50), kinek varchar(50))
insert termek(id, eladva) values (1, 'nincs eladva')
insert termek(id, eladva) values (2, 'nincs eladva')
select * from termek
update termek set eladva='nincs eladva', kinek=null where id=2
go
set tran isolation level read committed --ez a default
go
begin tran
declare @eladva varchar(50)
select @eladva=eladva from termek where id=2 -- vizsgalat
if @eladva='nincs eladva' begin
    waitfor delay '00:00:10' --most terheljük az illeto bankszámláját
    update termek set eladva='eladva', kinek='D' where id=2
    print 'eladás megtörtént'
end else print 'eladás sikertelen'
commit tran
go

--egy masik kapcsolatot nyitni, ezzel a koddal:
--set tran isolation level read committed --ez a default
--set tran isolation level repeatable read
set tran isolation level serializable
go
begin tran
declare @eladva varchar(50)
select @eladva=eladva from termek where id=2 -- vizsgalat
if @eladva='nincs eladva' begin
    waitfor delay '00:00:05' --most terheljük az illeto bankszámláját
    update termek set eladva='lefoglalózva', kinek='B' where id=2
    print 'eladás megtörtént'
end else print 'eladás sikertelen'
commit tran
go
--a ket kodot egyszerre elinditani
select * from termek --eredmeny: eladva vagy lefoglalozva attol fuggoen, hogy melyik indult hamarabb
update termek set eladva='nincs eladva', kinek=null where id=2

--ez az izolácios elképzelésünket sérti: mindkét tr. azt hiszi, hogy csak ő adta el a 2. terméket!!!
--(logikai hiba)
--és ez a default!
--VISZONT: mindkét tr. csak 10 s-ig futott... (nem álltak be egymás mögé)

--ugyanez repeatable read esetén
--eredmeny:
Transaction (Process ID 53) was deadlocked on lock resources with another process and has been chosen as the deadlock victim. Rerun the transaction.
--mivel mindketto kert egy shared lock-ot, es egyik sem tudta ezt exclusive-ve atalakitani...
--futasidok: 16 ill. 12 s (2 s-ig vart a szerver, hatha feloldodik a deadlock magatol)
--nincs logikai hiba, csak egy eladas tortent

--ennek a helyzetnek nincs megoldasa (pech): a ket muvelet koze ne tegyunk delay-t

--ellenorzes:  egyikbol kiszedni a vizsgalatot es kesleltetest, csak update maradjon
--ekkor nem lesz deadlock, es csak egyszer adjuk el.

-- ESETTANULMÁNY: repjegyes példa, demo (csak egy embernek sikerülhet)
delete jegy

-- rep.jegy foglalas, SQL tranzakcios gyakorlat
-- 2001 szept., Vassanyi Istvan
set transaction isolation level serializable
set xact_abort on
set nocount on
declare @jszam int, @jid int, @pid int, @utnapja datetime, @napikod smallint
declare @pnev varchar(50), @ind varchar(50), @cel varchar(50)
declare @jegyar money, @egyenleg money, @helyszam smallint

set @jszam=637 set @utnapja='2001.10.23' set @napikod=2 set @pid=2--ezek a parameterek a kliens programbol jonnek
                    --feltesszuk, hogy letezo rekordokra utalnak /ezt kulonben vizsgalni kellene/
select @ind=IndAll, @cel=CelAll from JaratTA where Jszam=@jszam
select @pnev=Pnev from Partner where PID=@pid
print 'Jegyfoglalás és -vétel ' + @pnev + ' számára ' + @ind + '-' + @cel + ' viszonylatban.'
print 'Tranzakció indítása...'
begin transaction
                --van-e eleg penze
select @egyenleg=Egyenleg from Partner where PID=@pid
select @jegyar=Jegyar from JaratTA where Jszam=@jszam
if @egyenleg < @jegyar begin
    raiserror('A tranzakció sikertelen. A hiba oka: nincs fedezet.', 17,17)
    rollback transaction
    goto vege
end
                --van-e hely
select @jid=JID, @helyszam=HelySzam from Jarat where Jszam=@jszam and UtNapja=@utnapja and NapiKod=@napikod
if @helyszam <= 0 begin
    raiserror('A tranzakció sikertelen. A hiba oka: nincs hely.', 17,17)
    rollback transaction
    goto vege
end
                --van-e mar jegye
if exists (select * from Jegy where PID=@pid and JID=@jid) begin
    raiserror('A tranzakció sikertelen. A hiba oka: a partnernek erre a járatra van már jegye.', 17,17)
    rollback transaction
    goto vege
end
waitfor delay '00:00:01'
                --tranz. OK
update Partner set Egyenleg=Egyenleg-@jegyar where PID=@pid
update Jarat set Helyszam=Helyszam-1 where JID=@jid
insert Jegy (PID, JID) values (@pid, @jid)
print 'A tranzakció sikeres.'
commit transaction

vege:  --visszateres

go

--teszt: set transaction isolation level serializable hatása: tovább tart a (sok) tranzakció

