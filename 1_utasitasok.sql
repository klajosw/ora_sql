-- el�gaz�sok
IF <felt�tel> THEN <utas�t�sok>
ELSIF <felt�tel> THEN <utas�t�sok>
ELSE <utas�t�sok>
END IF;

CASE <szelektor_kifejez�s>
  WHEN {<kifejez�s> | <felt�tel>} THEN <utas�t�sok>
  WHEN {<kifejez�s> | <felt�tel>} THEN <utas�t�sok>
  ELSE <utas�t�sok>
END CASE;

-- ciklusok
---- alapciklus
LOOP
 <utas�t�sok>
END LOOP;

---- FOR
FOR <ciklusv�ltoz�> IN [REVERSE] <als�_hat�r> .. <fels�_hat�r>
LOOP
 <utas�t�sok>
END LOOP;

---- WHILE
WHILE <felt�tel> 
LOOP 
 <utas�t�sok>
END LOOP;










