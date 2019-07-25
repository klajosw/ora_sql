--egy mezõt kérdezünk le
DECLARE
  TYPE tClientName IS VARRAY(10) OF fm_client.client_name%TYPE;
  sClientName tClientName;
  CURSOR cClient IS
    SELECT client_name FROM fm_client WHERE rownum < 100;
BEGIN
  OPEN cClient;
  LOOP
    FETCH cClient BULK COLLECT
      INTO sClientName LIMIT 10;
    EXIT WHEN sClientName.count = 0;
    FOR i IN 1 .. sClientName.COUNT LOOP
      dbms_output.put_line(sClientName(i));
    END LOOP;
  END LOOP;
  CLOSE cClient;
END;

--teljes rekordot lekérdezünk
DECLARE
  TYPE tClient IS VARRAY(10) OF fm_client%ROWTYPE;
  sClient tClient;
  CURSOR cClient IS
    SELECT * FROM fm_client WHERE rownum < 10;
BEGIN
  OPEN cClient;
  LOOP
    FETCH cClient BULK COLLECT
      INTO sClient LIMIT 10;
    EXIT WHEN sClient.count = 0;
    FOR i IN 1 .. sClient.COUNT LOOP
      dbms_output.put_line(sClient(i).client_name);
    END LOOP;
  END LOOP;
  CLOSE cClient;
END;

--csak megadott mezõket kérdezünk le
DECLARE
  TYPE rClient IS RECORD(
    client_no   fm_client.client_no%TYPE,
    client_name fm_client.client_name%TYPE);
  TYPE tClient IS VARRAY(10) OF rClient;
  sClient tClient;
  CURSOR cClient IS
    SELECT client_no, client_name FROM fm_client WHERE rownum < 100;
BEGIN
  OPEN cClient; LOOP
    FETCH cClient BULK COLLECT
      INTO sClient LIMIT 10;
    EXIT WHEN sClient.count = 0;
    FOR i IN 1 .. sClient.COUNT LOOP
      dbms_output.put_line(sClient(i)
                           .client_no || ' ' || sClient(i).client_name);
    END LOOP;
  END LOOP;
  CLOSE cClient;
END;



/* Sebesség demonstráció */

create table client (
client_no varchar2(6),
client_name varchar2(50)
);

truncate table client;
drop table client;

select * from client;

--sima kurzor 7.837s
DECLARE
  sClientNo   fm_client.client_no%TYPE;
  sClientName fm_client.client_name%TYPE;
  CURSOR cClient IS
    SELECT client_no, client_name FROM fm_client WHERE rownum < 100001;
BEGIN
  DELETE FROM client;
  COMMIT;
  OPEN cClient;
  LOOP
    FETCH cClient
      INTO sClientNo, sClientName;
    EXIT WHEN cClient%NOTFOUND;
    INSERT INTO client VALUES (sClientNo, sClientName);
  END LOOP;
  CLOSE cClient;
  COMMIT;
END;

--BULK COLLECT 
--LIMIT 1000 - 0.181s
truncate table client;
DECLARE
  TYPE tClientNo IS VARRAY(1000) OF fm_client.client_no%TYPE;
  TYPE tClientName IS VARRAY(1000) OF fm_client.client_name%TYPE;
  sClientNo   tClientNo;
  sClientName tClientName;
  CURSOR cClient IS
    SELECT client_no, client_name FROM fm_client WHERE rownum < 100001;
BEGIN
  DELETE FROM client;
  COMMIT;
  OPEN cClient;
  LOOP
    FETCH cClient BULK COLLECT
      INTO sClientNo, sClientName LIMIT 1000;
    EXIT WHEN sClientNo.COUNT = 0;
    FORALL i IN 1 .. sClientNo.COUNT
      INSERT INTO client VALUES (sClientNo(i), sClientName(i));
  END LOOP;
  CLOSE cClient;
  COMMIT;
END;


