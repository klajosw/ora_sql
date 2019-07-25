-- elágazások
IF <feltétel> THEN <utasítások>
ELSIF <feltétel> THEN <utasítások>
ELSE <utasítások>
END IF;

CASE <szelektor_kifejezés>
  WHEN {<kifejezés> | <feltétel>} THEN <utasítások>
  WHEN {<kifejezés> | <feltétel>} THEN <utasítások>
  ELSE <utasítások>
END CASE;

-- ciklusok
---- alapciklus
LOOP
 <utasítások>
END LOOP;

---- FOR
FOR <ciklusváltozó> IN [REVERSE] <alsó_határ> .. <felsõ_határ>
LOOP
 <utasítások>
END LOOP;

---- WHILE
WHILE <feltétel> 
LOOP 
 <utasítások>
END LOOP;










