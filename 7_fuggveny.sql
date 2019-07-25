CREATE OR REPLACE FUNCTION <függvény_neve>( <paraméterek> )
  RETURN <visszaadott_érték_adattípusa>
IS
  <visszaadott_változó_neve> <visszaadott_változó_adattípusa> ;
BEGIN
  <utasítások> 
  RETURN <visszaadott_változó_neve>;
END;



CREATE OR REPLACE FUNCTION osszefuzo(string1 IN VARCHAR2,
                                     string2 IN VARCHAR2 DEFAULT '')
  RETURN VARCHAR2 IS
  egyutt VARCHAR2(1000);
BEGIN
  egyutt := string1 || string2;
  RETURN egyutt;
END;



SELECT osszefuzo('Dear ', first_name) osszefuzve
  FROM customers;
  

 
