select distinct lpad(' ',p.DEPTH,' ')|| p.operation||' '||p.options  operation,p.ID,p.PARENT_ID,p.OBJECT_OWNER,p.OBJECT_NAME,cost,cardinality,bytes,p.OTHER_TAG,p.OTHER,p.DISTRIBUTION,p.ACCESS_PREDICATES,p.FILTER_PREDICATES , round(p.TEMP_SPACE/1024/1024/1024,3) temp_gigs, p.PARTITION_START, p.PARTITION_STOP
  from v$sql_plan p 
 where sql_id = 'b1j9sj7hzj40t'
 --and plan_hash_value =2358053040
 --where (p.sql_id,p.child_number)=(select sql_id, sql_child_number from v$session s where sid=636)
 --and p.OPERATION not like '%PX%'
 order by id;

select *
  from v$sql_optimizer_env e
 where (e.sql_id,e.child_number)=(select sql_id, sql_child_number from v$session s where sid=71)
 order by id;
