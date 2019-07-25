DECLARE
sql_stmt VARCHAR2(2000);
BEGIN
  FOR rec IN 
  (
     select t.nev from tmp_tanulo t
  ) LOOP
    sql_stmt :=
    ' select t.nev, j.idopont, j.ertek from tmp_tanulo t ' ||
    ' join tmp_jegy j on t.id=j.tanulo_id  where t.nev =''' || rec.nev || ''' ' ||
    ' order by 2,1' ;
   
    dbms_output.put_line(sql_stmt);
   -- EXECUTE IMMEDIATE sql_stmt; 
  
  END LOOP;
  
END;
/
