--#1 ÖNÁLLÓ FELADAT: 'A'-val kezd?d? nev? szerz?k születési éve
use pubs_access
select [Year Born]
from Authors where Author like 'A%'

--#2 ÖNÁLLÓ FELADAT: a legrégebbi kiadási dátum
select min([Year Published])
from Titles 

--#3 ÖNÁLLÓ FELADAT: a legrégebben kiadott könyv címe
--update Titles set [Year Published]=1993 where [Year Published]=0

select title
from Titles
where [Year Published] = (select min([Year Published]) from Titles)

--#4 ÖNÁLLÓ FELADAT: 1991-ben kiadott könyvek kiadói
select [Company Name]
from Publishers p inner join Titles t on p.PubID=t.PubID
where t.[Year Published]=1991

--#5 ÖNÁLLÓ FELADAT: 1997 el?tt intézett rendelések ügynökei (Lastname)
use northwind
select lastname, *
from orders o inner join employees e on o.EmployeeID=e.EmployeeID
where o.OrderDate<'1998-01-01'

--#6 ÖNÁLLÓ FELADAT: Fuller nev? üzletköt? által eladott termékek neve (4 tábla)

select p.ProductName
from Products p inner join [Order Details] od on od.ProductID=p.ProductID
inner join Orders o on o.OrderID=od.OrderID 
inner join Employees e on e.EmployeeID=o.EmployeeID
where e.LastName='Fuller'

--#7 ÖNÁLLÓ FELADAT: melyik termék nem szerepel egy rendelésen sem
select p.ProductName, p.ProductID
from Products p left outer join [Order Details] od on od.ProductID=p.ProductID
where od.ProductID is null

--#8 ÖNÁLLÓ FELADAT: melyik kiadónak hány könyve jelent meg eddig
use pubs_access
select p.PubID, p.[Company Name], COUNT(isbn) as db
from Publishers p left outer join Titles t on p.PubID=t.PubID
group by p.PubID, p.[Company Name]
order by db desc

--#9 ÖNÁLLÓ FELADAT: melyik termékkategória (Categories) bonyolította le az 1997-es évben a legnagyobb forgalmat? Hány termékkel?
use northwind
select top 1 c.CategoryID, c.CategoryName, count(distinct p.productid) as termekszam, sum((1-discount)*od.unitprice*quantity) as osszeg
from Categories c inner join Products p on c.CategoryID=p.CategoryID
inner join [Order Details] od on od.ProductID=p.ProductID
inner join Orders o on o.OrderID=od.OrderID
where year(o.OrderDate)=1997
group by c.CategoryID, c.CategoryName
order by osszeg desc

--4	Dairy Product	10	115387.63993454

--#10 ÖNÁLLÓ FELADAT: melyik a legtöbb könyvvel rendelkez? kiadó?
use pubs_access
select top 1 p.PubID, p.[Company Name], COUNT(isbn) as db
from Publishers p inner join Titles t on t.PubID=p.PubID
group by p.PubID, p.[Company Name]
order by db desc

--715	Prentice Hall Div. of Simon & Schuster, Inc.	542


--#11 ÖNÁLLÓ FELADAT Melyik ügynök adta el a legtöbbet a legkeresettebb termékbol és mi az a termék?
use northwind
select top 1 u.titleofcourtesy+' '+u.lastname+' '+ u.firstname +' ('+u.title +')'  as nev,
    sum(quantity) as hanyat_adott_el
    ,pr.productname as mibol
from orders o inner join [order details] d on o.orderid=d.orderid
    inner join employees u on u.employeeid=o.employeeid
    inner join products pr on pr.productid=d.productid
where d.productid =
    (select top 1 p.productid
    from products p left outer join [order details] d on p.productid=d.productid
    group by p.productid, p.productname
    order by count(*) desc)
group by u.employeeid, u.titleofcourtesy, u.title, u.lastname, u.firstname
, pr.ProductID,pr.productname  --ha látni akarjuk azt is, hogy mi a legkeresettebb termék
        --nem okozhat hibát, mert a where elobb szur, mint a group
order by sum(quantity) desc

--Ms. Leverling Janet (Sales Representative)	393 db.	Boston Crab Meat

--#12 ÖNÁLLÓ FELADAT A legtermékenyebb szerz? melyik kiadónál publikált legtöbbször?
use pubs_access
select top 1 a.Au_ID--, COUNT(*)
from Authors a inner join TitleAuthor ta on a.Au_ID=ta.Au_ID
group by a.au_id
order by COUNT(*) desc

select p.[Company Name] as kiado, COUNT(*) as konyvek_szama, au2.Author
from Publishers p inner join Titles t on p.PubID=t.PubID
inner join TitleAuthor ta2 on t.ISBN=ta2.ISBN 
inner join Authors au2 on au2.Au_ID=ta2.Au_ID
where ta2.Au_ID= (
	select top 1 a.Au_ID--, COUNT(*)
	from Authors a inner join TitleAuthor ta on a.Au_ID=ta.Au_ID
	group by a.au_id
	order by COUNT(*) desc
)
group by p.PubID, p.[Company Name], au2.Au_ID, au2.Author
having COUNT(*) > 2
order by konyvek_szama desc

--Prague, Carry 62 könyve közül 14 jelent meg a TAB BOOKS-nál

--#13 ÖNÁLLÓ FELADAT: a megjelent könyvek száma kiadónként és évente 

select p.[Company Name] as ceg, p.PubID, t.[Year Published] as ev, COUNT(isbn) as szam
from Publishers p inner join Titles t on p.PubID=t.PubID
group by p.PubID, p.[Company Name], t.[Year Published]
order by p.PubID --debug céljára

--#14 ÖNÁLLÓ FELADAT: meyik kiadó hány könyvet ad ki évente átlagosan?

use pubs_access
drop table #pp
select p.[Company Name] as ceg, p.PubID, t.[Year Published] as ev, COUNT(isbn) as szam
into #pp
from Publishers p inner join Titles t on p.PubID=t.PubID
group by p.PubID, p.[Company Name], t.[Year Published]
order by p.PubID --debug céljára

select PubID, ceg, AVG(szam) as atlag
from #pp 
group by pubid, ceg
order by atlag desc

--#15 ÖNÁLLÓ FELADAT: melyik kiadó melyik évben adta ki a legtöbb könyvét? 

select *
from #pp 
where CAST(pubid as varchar(50))+' '+CAST(szam as varchar(50)) in (  --a ' ' azért kell, hogy ne alakulhassanak ki kétértelm? azonosítók
	select CAST(pubid as varchar(50))+' '+CAST(max(szam) as varchar(50))
	from #pp
	group by pubid)
	

--#16 ÖNÁLLÓ FELADAT
--a northwind.employees táblát másoljuk át a saját adatbázisunkba
--"select ... into" módszerrrel
--írjunk egy lekérdezést, ami a mez?-orientált alakból a rekord-orientált
--alakot állítja el?,
--az EmployeeID, Lastname, Address, City mezokre (union)!
use ab81
select * into my_emp from northwind.dbo.Employees
create table my_emp_rec (empid integer not null, property_code varchar(50) not null, property_value varchar (200))

use ab81
select employeeid, 1, lastname from my_emp
union all
select employeeid, 2, Address from my_emp
union all
select employeeid, 3, City from my_emp

/***************************************
#17 ÖNÁLLÓ FELADAT: Melyek azok a f?városok, melyek 1000 km sugarú környezetében nincs hegy?

1) keressük meg azokat a városokat, melyeknek 1000 km 
sugarú környezetében VAN hegy
2) ez alapján (al-lekérdezéssel) keressük meg azokat a városokat, melyeknek 1000 km 
sugarú környezetében NINCS hegy
3) és rajzoljuk ki ezen városok körüli 
1000km sugarú buffer területeket
4) a foltokba írjuk bele a város nevét! (select label column: nev
5) sz?kítsük a találatokat a f?városokra (a country táblából)!

--hetven ilyen f?város van
********************************************/

select Name as nev, geog.STBuffer(1000000) as buffer 
			--ha nincs alias neve a Name mez?nek, nem teszi ki a címkét
from city where Name not in (
	select city.Name as varosnev
	from city, mountain
	where city.geog.STDistance(mountain.geog) < 1000000
) and geog is not null
and Name in (select capital from country)

--#18 ÖNÁLLÓ FELADAT a fenti script alapján: 
--1. egy új tábla létrehozása, 2. 100 véletlen float értékkel feltöltése
--3. listázása és 4. törlése

declare @i int
if exists (select * from dbo.sysobjects
        where id = object_id('[dbo].[veletlen]')
        and OBJECTPROPERTY(id, 'IsUserTable') = 1)
    drop table [dbo].[veletlen]

create table veletlen (szam float)
set @i=1
while @i<=100 begin
    insert veletlen (szam) values (100*rand())
    set @i=@i+1
end
select * from veletlen
drop table veletlen

/*********************************************************
#19 ÖNÁLLÓ FELADAT:
Raktárkészlet-karbantartó script illetve tárolt eljárás

Az eljárást a raktáros használja arra, hogy egy
létezo termék raktárkészletét növelje, vagy egy új cikket vegyen fel
a raktárba.

bemen? paraméterek:
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

select * into products from northwind.dbo.Products
select * into suppliers from northwind.dbo.Suppliers

drop procedure raktar_bovit 
create procedure raktar_bovit
@nev varchar(50),
@mennyiseg int,
@szallitonev varchar(50)
as
set nocount on
declare @talalatok_szama int, @uj_termek_id int, @uj_szallito_id int, @talalat_szallito int
select @talalatok_szama = count(*) from products
        where productName like '%' + @nev + '%'    ;
if @talalatok_szama = 1
    begin
        update products set unitsinstock = unitsinstock + @mennyiseg
            where productName like '%' + @nev + '%'
        print 'Mennyiség módosítva'
    end
else if @talalatok_szama = 0 --új termék
    begin
    --a szállító ellenõrzése, felvétele
		select @talalat_szallito=COUNT(*) from suppliers 
			where CompanyName like '%' + @szallitonev + '%'
		if @talalat_szallito = 1
			select @uj_szallito_id=supplierid from suppliers 
				where CompanyName like '%' + @szallitonev + '%'	 
		else if @talalat_szallito = 0 
		begin  --új szállító
			insert suppliers (CompanyName) values (@szallitonev)
			set @uj_szallito_id=@@identity
			print 'Új szállító felvéve: ' + cast(@uj_szallito_id as varchar(50))
		end else begin
			print 'Túl sok találat, kérem pontosítsa a szállító nevét!'
			return
		end
        insert products (productname, unitsinstock, discontinued, SupplierID)
            values(@nev, @mennyiseg, 0, @uj_szallito_id)
        set @uj_termek_id = @@identity
        print 'Új termék felvéve: ' + cast(@uj_termek_id as varchar(50))
    end
    else if @talalatok_szama <= 10 --választás
    begin
        print 'Több találat, kérem, válasszon a listából!'
		select * from products where productName like '%' + @nev + '%'    ;
    end else  --pontosítás
        print 'Túl sok találat, kérem pontosítsa a terméknevet!'

--TESZTELÉS:

raktar_bovit '%', 12, 'x comp'

raktar_bovit 'raclette c', 12, 'x comp'
select * from products where productName like '%raclette c%'

raktar_bovit 'raclette, nagyon új', 12, 'x comp'
select * from products where productName like '%raclette, nagyon új%'

raktar_bovit 'rac', 12, 'x comp'
select * from products where productName like '%raclette, nagyon új%'

raktar_bovit 'raclette, legujabb', 12, 'Gai'
select * from suppliers where CompanyName like '%Gai%'

raktar_bovit 'raclette, legeslegujabb', 12, 'Új cégnév'
select * from suppliers where CompanyName like '%Új%'
select * from products where productName like '%raclette%'

--#21 ÖNÁLLÓ FELADAT: kapott nev? vásárló egyenlegének növelése 10%-kal
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

--#23 ÖNÁLLÓ FELADAT: 
--írjunk függvényt, amely két, datetime típusú változó közül
--visszaadja a korábbit, ha valamelyik null, akkor pedig a 'N.A.' stringet!
--tesztelés az orders táblán
use ab81
drop function korabbi
create function korabbi (@d1 datetime, @d2 datetime) returns varchar(50) as
begin
	declare @eredm varchar(50)
	if @d1<=@d2 set @eredm=@d1 else if @d2<@d1 set @eredm=@d2 else set @eredm='N.A.'
	return @eredm
end

select diak81.korabbi('1997-02-08','2001-01-30')
select diak81.korabbi('2007-02-08','2001-01-30')
select diak81.korabbi(null,'2001-01-30')


--#24 ÖNÁLLÓ FELADAT (könny?)
--olyan script, amely az amerikai vásárlók (customers tábla, country mez?) rekordjain 
--végiglépked és kiírja minden vásárló nevét, és hogy eddig hány rendelése volt

declare @custid nchar(5), @custname nvarchar(40), @orders int
declare c cursor for 
	select customerid, companyname
	from customers where country='USA'
open c
fetch next from c into @custid, @custname
while @@FETCH_STATUS = 0 begin
	select @orders=COUNT(orderid) from orders where CustomerID=@custid
	print @custname + ': ' + cast(@orders as varchar(50)) + ' orders'
	fetch next from c into @custid, @custname	
end
close c deallocate c

-- a fenti ciklus egyenérték? ezzel az sql lekérdezéssel:

select companyname + ': ' + cast(COUNT(orderid) as varchar(50)) + ' orders'
from customers c inner join orders o on c.CustomerID=o.CustomerID
where c.country='USA'
group by c.CustomerID, c.CompanyName

--melyik az egyszer?bb?

/*************************************************************
#25 ÖNÁLLÓ FELADAT (NEHÉZ)

A feladat annak kiderítése, hogy a paraméterként kapott
ügynök

1) milyen átlagos gyakorisággal (napokban mérve) köt nagy érték? rendelést, illetve
2) hányszor fordult elo vele, hogy két kis érték? rendelése közvetlenül követte egymást

nagy érték?nek a 200 dollár feletti rendelések számítanak. Tehát ha pl. egy ügynök
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
Vagy próbáljuk ugyanezt elvégezni két egymásba ágyazott kurzorral (a küls?
az ügynökökön lépked végig, a bels? az illet? rendelésein)

**************************************************************************/
use northwind
declare @empid int 
set @empid=2 --debug: neki többször is van két kicsi egymás után
declare @datum date, @elozo_datum date, @osszeg float, @elozo_osszeg float, @ket_kicsi_egymas_utan int
declare @osszes_nap int, @rendelések_szama int
declare c cursor for 
	select o.orderdate, sum((1-discount)*unitprice*quantity)
	from orders o inner join [order details] d on o.orderid=d.orderid
	where EmployeeID = @empid
	group by o.orderid, o.orderdate
	order by o.orderdate

set @ket_kicsi_egymas_utan = 0
set @osszes_nap = 0
set @rendelések_szama = 0

open c
fetch next from c into @datum, @osszeg
while @@FETCH_STATUS = 0 begin
	if @elozo_datum is not null  --nem az elsõ rekord
		set @osszes_nap = @osszes_nap + DATEDIFF(DAY, @elozo_datum, @datum)
	if @osszeg >= 200
		set @rendelések_szama = @rendelések_szama + 1
	if @osszeg < 200 and @elozo_osszeg < 200 begin
		set @ket_kicsi_egymas_utan = @ket_kicsi_egymas_utan + 1
		--print 'második kicsi: ' + cast(@datum as varchar(50))  --debug
	end
	set @elozo_datum = @datum
	set @elozo_osszeg = @osszeg
	fetch next from c into @datum, @osszeg
end
close c deallocate c
--print @rendelések_szama
--print @osszes_nap
print 'átlagos idõ két nagyértékû rendelés között: ' + cast( @osszes_nap * 1.0 / (@rendelések_szama * 1.0) as varchar(50))
print 'hányszor jött két kis értékû rendelés egymás után: ' + cast(@ket_kicsi_egymas_utan  as varchar(50))

go

--tesztelés:
	select o.orderdate, sum((1-discount)*unitprice*quantity)
	from orders o inner join [order details] d on o.orderid=d.orderid
	where EmployeeID = 2 
	group by o.orderid, o.orderdate
	--having sum((1-discount)*unitprice*quantity) >= 200
	order by  o.orderdate	--85 nagy érétkû rendelés
	
	select datediff(day, '1996-07-25 00:00:00.000', '1998-05-05 00:00:00.000') --649

--Ez alapján a @rendelések_szama és a @osszes_nap értéke jó

--A @ket_kicsi_egymas_utan az idõsor végignézésével és a "második kicsi" kiíratásával ellenõrizhetõ