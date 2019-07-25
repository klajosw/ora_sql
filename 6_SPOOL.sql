set serveroutput on
spool s:\PLSQL_oktatas\SPOOL\SPOOL.txt
  DECLARE
    TYPE rt_Customer IS RECORD(
      first_name customers.first_name%TYPE,
      last_name  customers.last_name%TYPE);
    rCustomer rt_Customer;
    CURSOR cCustomer IS SELECT first_name, last_name FROM customers;
  BEGIN
    OPEN cCustomer;
    LOOP
      FETCH cCustomer INTO rCustomer; EXIT WHEN cCustomer%NOTFOUND;
      DBMS_OUTPUT.PUT_LINE(rCustomer.last_name || ', ' || rCustomer.first_name);
    END LOOP;
    CLOSE cCustomer;
  END;
/
spool off
./
exit 
