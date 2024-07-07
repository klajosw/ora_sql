alter session set nls_date_format='YYYY.MM.DD. HH24:MI:SS';

--mapping
select f.folder_name, m.*, v.* from snp_mapping m, snp_vcs_version_w v, snp_folder f
where f.i_folder = m.i_folder
and m.i_mapping = v.i_instance (+)
and i_objects (+) = 9700
and nvl(v.version_date,date '1000-01-01') < m.last_date
order by 1,3;

--datastore
select m.mod_name, m.lschema_name, t.*, v.* from snp_table t, snp_vcs_version_w v, snp_model m
where m.i_mod = t.i_mod
and t.i_table = v.i_instance (+)
and i_objects (+) = 2400
and nvl(v.version_date,date '1000-01-01') < t.last_date
order by 1,3;

--variable
select c.*, v.* from snp_var c, snp_vcs_version_w v
where c.i_var = v.i_instance (+)
and i_objects (+) = 3500
and nvl(v.version_date,date '1000-01-01') < c.last_date
order by 1,3;

--sequence
select s.*, v.* from snp_sequence s, snp_vcs_version_w v
where s.seq_id = v.i_instance (+)
and i_objects (+) = 3400
and nvl(v.version_date,date '1000-01-01') < s.last_date
order by 1,3;

--procedure/KM
select t.*, v.* from snp_trt t, snp_vcs_version_w v
where t.i_trt = v.i_instance (+)
and i_objects (+) = 3600
and nvl(v.version_date,date '1000-01-01') < t.last_date
--and t.trt_type = 'U'
and t.last_user != 'SUNOPSIS_INSTALL'
order by 1,3;

--load plan
select l.*, v.* from snp_load_plan l, snp_vcs_version_w v
where l.i_load_plan = v.i_instance (+)
and i_objects (+) = 8200
and nvl(v.version_date,date '1000-01-01') < l.last_date
order by 1,3;

--lschema
select l.*, v.* from snp_lschema l, snp_vcs_version v
where l.i_lschema = v.i_instance (+)
and i_objects (+) = 2100
and nvl(v.version_date,date '1000-01-01') < l.last_date
order by 1,3;


select * from snp_vcs_version where obj_current_path like '%EDW_RFX%'