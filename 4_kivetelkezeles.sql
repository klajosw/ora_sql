DECLARE
  szam_1 NUMBER := 5;
  szam_2 NUMBER := 0;
BEGIN
  dbms_output.put_line('Százalék: ' || (szam_1 / szam_2) * 100 || '%');
EXCEPTION
  WHEN zero_divide THEN
    dbms_output.put_line('Nullával akarsz osztani, olyat nem szabad...');
END;

DECLARE
  nSzuletesiEv NUMBER;
  nEletkor     NUMBER;
  adathiany EXCEPTION;
BEGIN
  --nSzuletesiEv := 1986;
  nEletkor := extract(YEAR FROM SYSDATE) - nSzuletesiEv;
  IF nSzuletesiEv IS NULL THEN
    RAISE adathiany;
  END IF;
  dbms_output.put_line(nEletkor);
EXCEPTION
  WHEN adathiany THEN
    dbms_output.put_line('Nem adtad meg a születési évet!');
END;







