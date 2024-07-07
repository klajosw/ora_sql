SET SERVEROUTPUT ON
DECLARE
  CURSOR demotablai IS 
    select table_name from all_tables where owner = 'DEMO';
  v VARCHAR2(500);
BEGIN
  FOR t in demotablai 
  LOOP
    v := 'GRANT select on ' || t.table_name || ' to &username';
    DBMS_OUTPUT.PUT_LINE(v);
    EXECUTE IMMEDIATE v; -- DDL utasítás végrehajtása
  END LOOP;
END;
/
