-- 1. feladat

select o.nev, count(r.id) as db
from balhal.orszagok o, balhal.teruletek t, balhal.reszlegek r
where o.id = t.orszag_id and t.id = r.terulet_id
group by o.nev;

-----------------------------------------------------

-- 2. feladat

with seged as
(select d.id, vnev, knev, fizetes - min_fizetes as kulonbseg
from balhal.dolgozok d, balhal.foglalkozasok f
where f.id = d.foglalkozas_id)
select id, vnev, knev
from seged
where kulonbseg = (select max(kulonbseg)
                  from seged);

-------------------------------------------------------

-- 3. feladat

with seged as
(select d1.vnev, d1.knev, count(d2.id) as db
from balhal.dolgozok d1, balhal.dolgozok d2
where d1.id = d2.menedzser_id
group by d1.knev, d1.vnev)
select vnev, knev, db
from seged
where db = (select max(db)
            from seged);

--------------------------------------------------------

-- 4. feladat

select r.id, r.nev, count(d.id) as db
from balhal.reszlegek r, balhal.dolgozok d
where d.reszleg_id = r.id
group by r.id, r.nev
having count(d.id) >= 4;

--------------------------------------------------------

-- 5. feladat

create view fonok(beoszt_vnev, beoszt_knev, fon_vnev, fon_knev) as
(select d2.vnev, d2.knev, d1.vnev, d1.knev
from balhal.dolgozok d1, balhal.dolgozok d2
where d1.id = d2.menedzser_id);

select *
from fonok;

drop view fonok;

----------------------------------------------------------

-- 6. feladat

with seged as
(select r.id, r.nev, avg(d.fizetes) as atlag
from balhal.dolgozok d, balhal.reszlegek r
where d.reszleg_id = r.id
group by r.id, r.nev)
select id, nev, atlag
from seged
where atlag > 10000;

-----------------------------------------------------------

-- 7. feladat

with seged as
(select max(fizetes) as maximum
from balhal.reszlegek r, balhal.dolgozok d
where r.id = d.reszleg_id
group by r.id
)
select avg(maximum) as atlag
from seged;
 
-- vagy (a második a jobb)

select avg(max(fizetes)) as atlag
from balhal.reszlegek r, balhal.dolgozok d
where r.id = d.reszleg_id
group by r.id;

----------------------------------------------------------

-- 8. feladat

select id, nev
from balhal.reszlegek r1
where not exists (select id
                  from balhal.foglalkozasok
                  where id not in (select foglalkozas_id
                                    from balhal.reszlegek r2, balhal.dolgozok d
                                    where d.reszleg_id = r2.id and
                                          r2.id = r1.id));

-----------------------------------------------------------

-- 9. feladat

select r.id, r.nev, max(fizetes) as legtobb
from balhal.reszlegek r, balhal.dolgozok d
where r.id = d.reszleg_id and d.vnev like 'B%'
group by r.id, r.nev
having max(fizetes) = (select max(fizetes)
                      from balhal.dolgozok
                      where vnev like 'B%');

-----------------------------------------------------------

-- 10. feladat

select count(*) as db
from balhal.orszagok o
where not exists (select r.id
                  from balhal.teruletek t, balhal.reszlegek r
                  where t.id = r.terulet_id and t.orszag_id = o.id);

-----------------------------------------------------------

-- 11. feladat

create table borton (
	id		varchar2(3),
	nev		varchar2(20),
	varos		varchar2(20),
	constraint bort_pr_k primary key(id),
	constraint ch_var check (lower(varos) in ('vac', 'szeged', 'budapest')));

create table fegyor (
	id		varchar2(3),
	nev		varchar2(30),
	szuletes	date,
	borton_id	varchar2(3),
	constraint fegy_pr_k primary key(id),
	constraint bor_f_k foreign key(borton_id) references borton(id));

insert into borton values
('B01', 'Csillag', 'Szeged');

insert into fegyor values
('F01', 'Kis Botond', date '1988-01-01', 'B01');

drop table fegyor;
drop table borton;

/* A két táblát csak ilyen sorrendben tudjuk létrehozni, majd eldobni az idegen
kulcs megszorítás miatt. */

