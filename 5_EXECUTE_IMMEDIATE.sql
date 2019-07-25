DECLARE
  sNev   VARCHAR2(30);
  sSQL   VARCHAR2(500);
BEGIN
  sNev   := 'orders';
  sSQL := 'DROP TABLE ' || sNev;
  EXECUTE IMMEDIATE sSQL;
END;


--https://docs.oracle.com/cd/B19306_01/appdev.102/b14261/dynamic.htm

DECLARE
  customer_id customers.customer_id%TYPE := 100;
  last_name   customers.last_name%TYPE := 'Kocsisné Gál';
  first_name  customers.first_name%TYPE := 'Zsuzsa';
  city        customers.city%TYPE := 'Budapest';
  company     customers.company%TYPE := 'ERSTE';
  sSQL VARCHAR2(500);
BEGIN
  sSQL := 'BEGIN ';
  sSQL := sSQL || 'INSERT INTO customers values(:a, :b, :c, :d, :e);';
  sSQL := sSQL || 'END;';
  EXECUTE IMMEDIATE sSQL
    USING customer_id, last_name, first_name, city, company;
END;

