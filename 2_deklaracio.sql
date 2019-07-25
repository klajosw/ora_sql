SELECT * FROM orders;
SELECT * FROM customers order by city;


/* Alap adattípusok */
DECLARE
  sOrderID   NUMBER := 40;
  dOrderDate DATE;
  sStatus    VARCHAR2(25) DEFAULT 'Credit Card';
BEGIN
  dbms_output.put_line('Order ID: ' || sOrderID);
  dbms_output.put_line('Order date: ' || to_char(dOrderDate, 'yyyy.mm.dd'));
  dbms_output.put_line('Status: ' || sStatus);
END;

--  Output
--------------------------
--  Order ID: 40
--  Order date: 
--  Status: Credit Card
--------------------------




/* %TYPE */
DECLARE
  nShippingFee orders.shipping_fee%TYPE DEFAULT 10;
  nRate CONSTANT NUMBER := 275;
  nSzallitasiKoltseg nShippingFee%TYPE;
BEGIN
  dbms_output.put_line('Shipping fee: ' || nShippingFee || ' USD');
  nSzallitasiKoltseg := nShippingFee * nRate;
  dbms_output.put_line('Szállítási ktg: ' || nSzallitasiKoltseg || ' HUF');
END;

--  Output
--------------------------
--  Shipping fee: 10 USD
--  Szállítási ktg: 2750 HUF
--------------------------




/* %ROWTYPE */
DECLARE
  rCustomerRecord customers%ROWTYPE;
BEGIN
  SELECT * INTO rCustomerRecord FROM customers WHERE customer_id = 9;
  dbms_output.put_line(rCustomerRecord.last_name || ', ' ||
                       rCustomerRecord.first_name);
END;

--  Output
--------------------------
--  Mortensen, Sven
--------------------------




/* RECORD */
DECLARE
  TYPE rt_CustomerRecord IS RECORD(
    customer_id customers.customer_id%TYPE,
    city        customers.city%TYPE);
  rCustomerRecord rt_CustomerRecord;
BEGIN
  SELECT customer_id, city
    INTO rCustomerRecord
    FROM customers
   WHERE customer_id = 17;
  dbms_output.put_line(rCustomerRecord.city);
END;

--  Output
--------------------------
--  Seattle
--------------------------




/* Tömb */
DECLARE
  TYPE tStringTomb IS VARRAY(10) OF VARCHAR2(10);
  aStringTomb tStringTomb := tStringTomb();
BEGIN
  aStringTomb.extend(10);
  aStringTomb(1) := 'izé';
  aStringTomb(3) := 'bizé';
  dbms_output.put_line(aStringTomb(1));
  dbms_output.put_line(aStringTomb(2));
  dbms_output.put_line(aStringTomb(3));
END;

--  Output
--------------------------
--  izé
--
--  bizé
--------------------------




/* Asszociatív tömb */
DECLARE
  TYPE atHonapUtolsoNapja IS TABLE OF NUMBER INDEX BY VARCHAR2(15);
  at_HonapUtolsoNapja atHonapUtolsoNapja;
BEGIN
  at_HonapUtolsoNapja('január') := 31;
  at_HonapUtolsoNapja('február') := 28;
  
  dbms_output.put_line(at_HonapUtolsoNapja('január'));
  dbms_output.put_line(at_HonapUtolsoNapja('február'));
END;

--  Output
--------------------------
--  31
--  28
--------------------------




/* Beágyazott tábla */
CREATE TYPE szerzo AS TABLE OF VARCHAR2(50);

CREATE TABLE konyv (
id        NUMBER,
cim       VARCHAR2(500),
szerzok   szerzo)
NESTED TABLE szerzok STORE AS szerzok_oszlop;

INSERT INTO konyv
VALUES
  (1,
   'Gitáriskola',
   szerzo('Muszty Bea',
          'Dobay András'));
INSERT INTO konyv
VALUES
  (2,
   'Modern vállalati pénzügyek',
   szerzo('Brealy, Richard A.',
          'Myers, Stewart C. '));

DROP TABLE konyv;
DROP TYPE szerzo;




/* Implicit kurzor */
DECLARE
  sCity customers.city%TYPE;
BEGIN
  SELECT city
    INTO sCity
    FROM customers
   WHERE customer_id = 17;
  dbms_output.put_line(sCity);
END;

--  Output
--------------------------
--  Seattle
--------------------------




/* Explicit kurzor */
DECLARE
  sCity customers.city%TYPE;
  CURSOR cCity IS
    SELECT city
      FROM customers
     WHERE customer_id IN (17, 23);
BEGIN
  OPEN cCity;
  LOOP
    FETCH cCity INTO sCity;
    EXIT WHEN cCity%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE(sCity);
  END LOOP;
  CLOSE cCity;
END;

--  Output
--------------------------
--  Seattle
--  Portland
--------------------------




/* Kurzor paraméterezése */
DECLARE
  CURSOR cOrders(nShippingFee NUMBER) IS
    SELECT ship_name, SUM(shipping_fee)
      FROM orders
     WHERE shipping_fee >= nShippingFee
     GROUP BY ship_name
     ORDER BY SUM(shipping_fee) DESC;
  sShipName       orders.ship_name%TYPE;
  nSumShippingFee orders.shipping_fee%TYPE;
BEGIN
  OPEN cOrders(200);
  LOOP
    FETCH cOrders
      INTO sShipName, nSumShippingFee;
    EXIT WHEN cOrders%NOTFOUND;
    dbms_output.put_line(nSumShippingFee || ' - ' || sShipName);
  END LOOP;
  CLOSE cOrders;
END;

--  Output
----------------------------------
--  600 - Francisco Pérez-Olaeta
--  400 - Karen Toh
--  400 - Soo Jung Lee
----------------------------------




/* Kurzorváltozó */
DECLARE
  TYPE ctCustomer IS REF CURSOR RETURN customers%ROWTYPE;
  cCustomer     ctCustomer;
  rCustomer     customers%ROWTYPE;
  SCustomerName VARCHAR2(500);
BEGIN
  
  DBMS_OUTPUT.PUT_LINE('<<-- Boston -->>');
  OPEN cCustomer FOR
    SELECT * FROM customers WHERE city = 'Boston';
  LOOP
    FETCH cCustomer INTO rCustomer;
    EXIT WHEN cCustomer%NOTFOUND;
    SCustomerName := rCustomer.last_name || ', ' ||
                       rCustomer.first_name;
    DBMS_OUTPUT.PUT_LINE(SCustomerName);
  END LOOP;  
  --CLOSE cCustomer;
  
  dbms_output.new_line;


  DBMS_OUTPUT.PUT_LINE('<<-- Milwaukee -->>');
  OPEN cCustomer FOR
    SELECT * FROM customers WHERE city = 'Milwaukee';
  LOOP
    FETCH cCustomer INTO rCustomer;
    EXIT WHEN cCustomer%NOTFOUND;
    SCustomerName := rCustomer.last_name || ', ' ||
                       rCustomer.first_name;
    DBMS_OUTPUT.PUT_LINE(SCustomerName);
  END LOOP;  
  CLOSE cCustomer;
END;





