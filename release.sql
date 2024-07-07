select 'MAPPING#'||global_id, name from snp_mapping where i_folder not in (3) and name like 'MAP_CDR%LOAD' order by name; --where i_folder = 2 and name in ('MAP_FDB_DMEXBA_LOAD','MAP_FDB_DMEXBM_LOAD','MAP_FDB_DMEXPO_LOAD','MAP_FDB_EXSLBA_LOAD','MAP_FDB_EXSLPO_LOAD','MAP_FDB_SLLEAC_LOAD');
select 'PROCEDURE#'||global_id from snp_trt t where i_folder in (1,2);
select 'VARIABLE#'||global_id, var_name from snp_var order by var_name;-- where var_type = 'G';
select 'SEQUENCE#'||global_id from snp_sequence order by seq_name;
select 'USER_FUNCTION#'||global_id from snp_ufunc;
select 'KM#'||global_id from snp_trt t where i_project = 2 and i_folder is null;
select 'DATASTORE#'||global_id from snp_table order by table_name;-- t where i_mod in (36,47,111);
select 'LOAD_PLAN#'||global_id from snp_load_plan order by load_plan_name;-- where load_plan_name not in ('LP_EDW_LOAD');
select 'LSCHEMA#'||global_id, t.* from snp_lschema t where first_user != 'SUNOPSIS_INSTALL' order by lschema_name;

alter session set nls_date_format='YYYY.MM.DD. HH24:MI:SS';

