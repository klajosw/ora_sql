--#1 �N�LL� FELADAT: 'A'-val kezd?d? nev? szerz?k sz�let�si �ve
use pubs_access
select [Year Born]
from Authors where Author like 'A%'

--#2 �N�LL� FELADAT: a legr�gebbi kiad�si d�tum
select min([Year Published])
from Titles 

--#3 �N�LL� FELADAT: a legr�gebben kiadott k�nyv c�me
--update Titles set [Year Published]=1993 where [Year Published]=0

select title
from Titles
where [Year Published] = (select min([Year Published]) from Titles)

--#4 �N�LL� FELADAT: 1991-ben kiadott k�nyvek kiad�i
select [Company Name]
from Publishers p inner join Titles t on p.PubID=t.PubID
where t.[Year Published]=1991

--#5 �N�LL� FELADAT: 1997 el?tt int�zett rendel�sek �gyn�kei (Lastname)
use northwind
select lastname, *
from orders o inner join employees e on o.EmployeeID=e.EmployeeID
where o.OrderDate<'1998-01-01'

--#6 �N�LL� FELADAT: Fuller nev? �zletk�t? �ltal eladott term�kek neve (4 t�bla)

select p.ProductName
from Products p inner join [Order Details] od on od.ProductID=p.ProductID
inner join Orders o on o.OrderID=od.OrderID 
inner join Employees e on e.EmployeeID=o.EmployeeID
where e.LastName='Fuller'

--#7 �N�LL� FELADAT: melyik term�k nem szerepel egy rendel�sen sem
select p.ProductName, p.ProductID
from Products p left outer join [Order Details] od on od.ProductID=p.ProductID
where od.ProductID is null

--#8 �N�LL� FELADAT: melyik kiad�nak h�ny k�nyve jelent meg eddig
use pubs_access
select p.PubID, p.[Company Name], COUNT(isbn) as db
from Publishers p left outer join Titles t on p.PubID=t.PubID
group by p.PubID, p.[Company Name]
order by db desc

--#9 �N�LL� FELADAT: melyik term�kkateg�ria (Categories) bonyol�totta le az 1997-es �vben a legnagyobb forgalmat? H�ny term�kkel?
use northwind
select top 1 c.CategoryID, c.CategoryName, count(distinct p.productid) as termekszam, sum((1-discount)*od.unitprice*quantity) as osszeg
from Categories c inner join Products p on c.CategoryID=p.CategoryID
inner join [Order Details] od on od.ProductID=p.ProductID
inner join Orders o on o.OrderID=od.OrderID
where year(o.OrderDate)=1997
group by c.CategoryID, c.CategoryName
order by osszeg desc

--4	Dairy Product	10	115387.63993454

--#10 �N�LL� FELADAT: melyik a legt�bb k�nyvvel rendelkez? kiad�?
use pubs_access
select top 1 p.PubID, p.[Company Name], COUNT(isbn) as db
from Publishers p inner join Titles t on t.PubID=p.PubID
group by p.PubID, p.[Company Name]
order by db desc

--715	Prentice Hall Div. of Simon & Schuster, Inc.	542


--#11 �N�LL� FELADAT Melyik �gyn�k adta el a legt�bbet a legkeresettebb term�kbol �s mi az a term�k?
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
, pr.ProductID,pr.productname  --ha l�tni akarjuk azt is, hogy mi a legkeresettebb term�k
        --nem okozhat hib�t, mert a where elobb szur, mint a group
order by sum(quantity) desc

--Ms. Leverling Janet (Sales Representative)	393 db.	Boston Crab Meat

--#12 �N�LL� FELADAT A legterm�kenyebb szerz? melyik kiad�n�l publik�lt legt�bbsz�r?
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

--Prague, Carry 62 k�nyve k�z�l 14 jelent meg a TAB BOOKS-n�l

--#13 �N�LL� FELADAT: a megjelent k�nyvek sz�ma kiad�nk�nt �s �vente 

select p.[Company Name] as ceg, p.PubID, t.[Year Published] as ev, COUNT(isbn) as szam
from Publishers p inner join Titles t on p.PubID=t.PubID
group by p.PubID, p.[Company Name], t.[Year Published]
order by p.PubID --debug c�lj�ra

--#14 �N�LL� FELADAT: meyik kiad� h�ny k�nyvet ad ki �vente �tlagosan?

use pubs_access
drop table #pp
select p.[Company Name] as ceg, p.PubID, t.[Year Published] as ev, COUNT(isbn) as szam
into #pp
from Publishers p inner join Titles t on p.PubID=t.PubID
group by p.PubID, p.[Company Name], t.[Year Published]
order by p.PubID --debug c�lj�ra

select PubID, ceg, AVG(szam) as atlag
from #pp 
group by pubid, ceg
order by atlag desc

--#15 �N�LL� FELADAT: melyik kiad� melyik �vben adta ki a legt�bb k�nyv�t? 

select *
from #pp 
where CAST(pubid as varchar(50))+' '+CAST(szam as varchar(50)) in (  --a ' ' az�rt kell, hogy ne alakulhassanak ki k�t�rtelm? azonos�t�k
	select CAST(pubid as varchar(50))+' '+CAST(max(szam) as varchar(50))
	from #pp
	group by pubid)
	

--#16 �N�LL� FELADAT
--a northwind.employees t�bl�t m�soljuk �t a saj�t adatb�zisunkba
--"select ... into" m�dszerrrel
--�rjunk egy lek�rdez�st, ami a mez?-orient�lt alakb�l a rekord-orient�lt
--alakot �ll�tja el?,
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
#17 �N�LL� FELADAT: Melyek azok a f?v�rosok, melyek 1000 km sugar� k�rnyezet�ben nincs hegy?

1) keress�k meg azokat a v�rosokat, melyeknek 1000 km 
sugar� k�rnyezet�ben VAN hegy
2) ez alapj�n (al-lek�rdez�ssel) keress�k meg azokat a v�rosokat, melyeknek 1000 km 
sugar� k�rnyezet�ben NINCS hegy
3) �s rajzoljuk ki ezen v�rosok k�r�li 
1000km sugar� buffer ter�leteket
4) a foltokba �rjuk bele a v�ros nev�t! (select label column: nev
5) sz?k�ts�k a tal�latokat a f?v�rosokra (a country t�bl�b�l)!

--hetven ilyen f?v�ros van
********************************************/

select Name as nev, geog.STBuffer(1000000) as buffer 
			--ha nincs alias neve a Name mez?nek, nem teszi ki a c�mk�t
from city where Name not in (
	select city.Name as varosnev
	from city, mountain
	where city.geog.STDistance(mountain.geog) < 1000000
) and geog is not null
and Name in (select capital from country)

--#18 �N�LL� FELADAT a fenti script alapj�n: 
--1. egy �j t�bla l�trehoz�sa, 2. 100 v�letlen float �rt�kkel felt�lt�se
--3. list�z�sa �s 4. t�rl�se

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
#19 �N�LL� FELADAT:
Rakt�rk�szlet-karbantart� script illetve t�rolt elj�r�s

Az elj�r�st a rakt�ros haszn�lja arra, hogy egy
l�tezo term�k rakt�rk�szlet�t n�velje, vagy egy �j cikket vegyen fel
a rakt�rba.

bemen? param�terek:
set @termeknev = 'Raclette'
set @mennyiseg = 12
set @szallito = 'Formago Company'

A script '%raclette%'-re illo term�knevet keres a Products t�bl�ban.
Ha t�bb, mint 1 tal�lat van, hiba�zenettel kil�p.
Ha 1 tal�lat van, akkor annak a rakt�rk�szlet�t (unitsinstock) n�veli
12-vel.
Ha nincs tal�lat, akkor felvesz egy �j Raclette nevu term�ket, melynek a
sz�ll�t�j�t (supplier) a 3. param�ter alapj�n pr�b�lja be�ll�tani,
a fentihez hasonl� logik�val (t�bb tal�lat: hiba, 1 tal�lat: megvan,
0 tal�lat: �j supplier felv�tele)

A munk�t a saj�t adatb�zisban v�gezz�k, elosz�r is (ha kell) m�soljuk �t ide a
k�t t�bl�t!

1. l�p�s: olyan lek�rdez�s, amely visszaadja a mint�ra illeszkedo rekordok sz�m�t
2. l�p�s: besz�r� INSERT illetve m�dos�t� UPDATE utas�t�s �sszerak�sa
3. l�p�s: a lek�rdez�sek be�gyaz�sa egy IF felt�telt haszn�l� script-be
4. l�p�s: a script tesztel�se 
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
        print 'Mennyis�g m�dos�tva'
    end
else if @talalatok_szama = 0 --�j term�k
    begin
    --a sz�ll�t� ellen�rz�se, felv�tele
		select @talalat_szallito=COUNT(*) from suppliers 
			where CompanyName like '%' + @szallitonev + '%'
		if @talalat_szallito = 1
			select @uj_szallito_id=supplierid from suppliers 
				where CompanyName like '%' + @szallitonev + '%'	 
		else if @talalat_szallito = 0 
		begin  --�j sz�ll�t�
			insert suppliers (CompanyName) values (@szallitonev)
			set @uj_szallito_id=@@identity
			print '�j sz�ll�t� felv�ve: ' + cast(@uj_szallito_id as varchar(50))
		end else begin
			print 'T�l sok tal�lat, k�rem pontos�tsa a sz�ll�t� nev�t!'
			return
		end
        insert products (productname, unitsinstock, discontinued, SupplierID)
            values(@nev, @mennyiseg, 0, @uj_szallito_id)
        set @uj_termek_id = @@identity
        print '�j term�k felv�ve: ' + cast(@uj_termek_id as varchar(50))
    end
    else if @talalatok_szama <= 10 --v�laszt�s
    begin
        print 'T�bb tal�lat, k�rem, v�lasszon a list�b�l!'
		select * from products where productName like '%' + @nev + '%'    ;
    end else  --pontos�t�s
        print 'T�l sok tal�lat, k�rem pontos�tsa a term�knevet!'

--TESZTEL�S:

raktar_bovit '%', 12, 'x comp'

raktar_bovit 'raclette c', 12, 'x comp'
select * from products where productName like '%raclette c%'

raktar_bovit 'raclette, nagyon �j', 12, 'x comp'
select * from products where productName like '%raclette, nagyon �j%'

raktar_bovit 'rac', 12, 'x comp'
select * from products where productName like '%raclette, nagyon �j%'

raktar_bovit 'raclette, legujabb', 12, 'Gai'
select * from suppliers where CompanyName like '%Gai%'

raktar_bovit 'raclette, legeslegujabb', 12, '�j c�gn�v'
select * from suppliers where CompanyName like '%�j%'
select * from products where productName like '%raclette%'

--#21 �N�LL� FELADAT: kapott nev? v�s�rl� egyenleg�nek n�vel�se 10%-kal
--a V�s�rl� t�bl�ban
--itt m�r t�nyleg elofordulhat, hogy egy n�vre t�bb rekord is illik
--elj�r�s neve: bonus, param�ter a v�s�rl�n�v varchar(50)











--#22 �N�LL� FELADAT: kor�bbi v�letlen sz�mos feladatunk megval�s�t�sa t�rolt elj�r�sk�nt

create procedure sp_veletlen
@hany_szam int
as
declare @i int
--if exists: halad�knak
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

--#23 �N�LL� FELADAT: 
--�rjunk f�ggv�nyt, amely k�t, datetime t�pus� v�ltoz� k�z�l
--visszaadja a kor�bbit, ha valamelyik null, akkor pedig a 'N.A.' stringet!
--tesztel�s az orders t�bl�n
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


--#24 �N�LL� FELADAT (k�nny?)
--olyan script, amely az amerikai v�s�rl�k (customers t�bla, country mez?) rekordjain 
--v�gigl�pked �s ki�rja minden v�s�rl� nev�t, �s hogy eddig h�ny rendel�se volt

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

-- a fenti ciklus egyen�rt�k? ezzel az sql lek�rdez�ssel:

select companyname + ': ' + cast(COUNT(orderid) as varchar(50)) + ' orders'
from customers c inner join orders o on c.CustomerID=o.CustomerID
where c.country='USA'
group by c.CustomerID, c.CompanyName

--melyik az egyszer?bb?

/*************************************************************
#25 �N�LL� FELADAT (NEH�Z)

A feladat annak kider�t�se, hogy a param�terk�nt kapott
�gyn�k

1) milyen �tlagos gyakoris�ggal (napokban m�rve) k�t nagy �rt�k? rendel�st, illetve
2) h�nyszor fordult elo vele, hogy k�t kis �rt�k? rendel�se k�zvetlen�l k�vette egym�st

nagy �rt�k?nek a 200 doll�r feletti rendel�sek sz�m�tanak. Teh�t ha pl. egy �gyn�k
rendel�seinek a d�tumai az al�bbiak:

2011. jan. 3. (820 $)
2011. jan. 4. (190 $)
2011. jan. 5. (11,200 $)
2011. jan. 10. (100 $)
2011. jan. 11. (140 $)
2011. jan. 20. (540 $)

akkor
1) 2+15=17 nap alatt 3 nagy �rt�ku rendel�s, teh�t az �tlag 5.7 nap
2) egyszer fordult elo, hogy egym�s ut�n k�t kis�rt�ku rendel�s j�tt

A megold�s l�p�sei:

1. kurzor k�sz�t�se az illet� �gyn�k rendel�si d�tumaira �s azok �rt�k�re
(kor�bbi anyagb�l kioll�zhat� a lek�rdez�s), rendez�s d�tum szerint
2. a kurzor v�gigl�ptet�se, a rendel�s t�pus�nak ment�se k�t rekord k�z�tt egy v�ltoz�ba
3. tesztel�s az Orders t�bl�n

seg�ts�g:
select DATEDIFF(day, '2011-02-23', '2011-03-03') -- az eredm�ny 11, integer

Tov�bbfejleszt�s (SZORGALMI FELADAT): legyen ez egy t�rolt elj�r�sban, �s h�vjuk meg sorban minden �gyn�kre!
Vagy pr�b�ljuk ugyanezt elv�gezni k�t egym�sba �gyazott kurzorral (a k�ls?
az �gyn�k�k�n l�pked v�gig, a bels? az illet? rendel�sein)

**************************************************************************/
use northwind
declare @empid int 
set @empid=2 --debug: neki t�bbsz�r is van k�t kicsi egym�s ut�n
declare @datum date, @elozo_datum date, @osszeg float, @elozo_osszeg float, @ket_kicsi_egymas_utan int
declare @osszes_nap int, @rendel�sek_szama int
declare c cursor for 
	select o.orderdate, sum((1-discount)*unitprice*quantity)
	from orders o inner join [order details] d on o.orderid=d.orderid
	where EmployeeID = @empid
	group by o.orderid, o.orderdate
	order by o.orderdate

set @ket_kicsi_egymas_utan = 0
set @osszes_nap = 0
set @rendel�sek_szama = 0

open c
fetch next from c into @datum, @osszeg
while @@FETCH_STATUS = 0 begin
	if @elozo_datum is not null  --nem az els� rekord
		set @osszes_nap = @osszes_nap + DATEDIFF(DAY, @elozo_datum, @datum)
	if @osszeg >= 200
		set @rendel�sek_szama = @rendel�sek_szama + 1
	if @osszeg < 200 and @elozo_osszeg < 200 begin
		set @ket_kicsi_egymas_utan = @ket_kicsi_egymas_utan + 1
		--print 'm�sodik kicsi: ' + cast(@datum as varchar(50))  --debug
	end
	set @elozo_datum = @datum
	set @elozo_osszeg = @osszeg
	fetch next from c into @datum, @osszeg
end
close c deallocate c
--print @rendel�sek_szama
--print @osszes_nap
print '�tlagos id� k�t nagy�rt�k� rendel�s k�z�tt: ' + cast( @osszes_nap * 1.0 / (@rendel�sek_szama * 1.0) as varchar(50))
print 'h�nyszor j�tt k�t kis �rt�k� rendel�s egym�s ut�n: ' + cast(@ket_kicsi_egymas_utan  as varchar(50))

go

--tesztel�s:
	select o.orderdate, sum((1-discount)*unitprice*quantity)
	from orders o inner join [order details] d on o.orderid=d.orderid
	where EmployeeID = 2 
	group by o.orderid, o.orderdate
	--having sum((1-discount)*unitprice*quantity) >= 200
	order by  o.orderdate	--85 nagy �r�tk� rendel�s
	
	select datediff(day, '1996-07-25 00:00:00.000', '1998-05-05 00:00:00.000') --649

--Ez alapj�n a @rendel�sek_szama �s a @osszes_nap �rt�ke j�

--A @ket_kicsi_egymas_utan az id�sor v�gign�z�s�vel �s a "m�sodik kicsi" ki�rat�s�val ellen�rizhet�