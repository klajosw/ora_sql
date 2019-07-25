select t.BLOCKS, t.* from all_tables t where t.OWNER in (select username from USER_USERS)
and upper(t.TABLE_NAME) like upper('tmp_aa%')
order by nvl(t.BLOCKS,-1) desc, t.TABLE_NAME
;

SELECT SYS_CONTEXT('USERENV','SESSION_USER') FROM dual 

DROP TABLE TMP_AAAA;

CREATE TABLE tmp_aaaa (
  id          NUMBER GENERATED ALWAYS AS IDENTITY,
  description VARCHAR2(30)
);

INSERT INTO tmp_aaaa (description)  VALUES ('bbbbbbb');
select * from tmp_aaaa;

