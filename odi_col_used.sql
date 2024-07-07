select
    m.lschema_name,
    t.table_name,
    c.col_name,
    listagg(u.name,', ') within group (order by u.name) mapek
  from
    snp_model m,
    snp_table t,
    snp_col c,
    (
      select
          lschema_name,
          i_table,
          table_name,
          i_col,
          col_name,
          name,
          folder_name,
          coltype
      from
          (
              select
                  g.lschema_name,
                  a.i_table,
                  a.table_name,
                  b.i_col,
                  b.col_name,
                  f.name,
                  h.folder_name,
                  case when e.i_map_expr_ref is not null then 'S' else 'T' end coltype,
                  row_number() over (
                      partition by
                          g.lschema_name,
                          a.table_name,
                          b.col_name,
                          f.name
                      order by
                          h.lev desc
                  ) rownumber
              from
                  snp_table a,
                  snp_col b,
                  snp_map_ref c,
                  snp_map_attr d,
                  snp_map_expr_ref e,
                  (select * from snp_map_expr where to_char(substr(txt,1,2000)) not in ('#EDW.C_FLG_NOT_USED','#EDW.C_REF_NOT_USED','#EDW.C_REF_NOT_USED /*nem tudjuk a forrását*/')) e1,
                  snp_mapping f,
                  snp_model g,
                  (
                      select
                          a.i_folder,
                          sys_connect_by_path(folder_name,'/') folder_name,
                          level lev
                      from
                          snp_folder a
                      connect by
                          prior a.i_folder = par_i_folder
                  ) h
              where
                  b.i_table = a.i_table and
                  c.i_ref_id = b.i_col and
                  d.i_map_ref = c.i_map_ref and
                  e.i_ref_map_attr (+)= d.i_map_attr and
                  e1.i_owner_map_attr (+)= d.i_map_attr and
                  e1.txt (+) is not null and
                  f.i_mapping = c.i_owner_mapping and
                  g.i_mod = a.i_mod and
                  h.i_folder = f.i_folder and
                  (
                      e.i_map_expr_ref is not null or
                      e1.i_map_expr is not null
                  )
          )
      where
          rownumber = 1
    ) u
 where
    m.lschema_name = 'EDW_DW' and
    t.i_mod = m.i_mod and
    c.i_table = t.i_table and
    c.col_name not in ('LOAD_ID','UPDATE_ID','START_OF_VALIDITY','END_OF_VALIDITY','ROWID','I$DW_ACTIVE_FLG','ROWID') and
    u.i_table (+) = c.i_table and
    u.i_col (+) = c.i_col and
    u.coltype (+) = 'T'
 group by
    m.lschema_name,
    t.table_name,
    c.col_name
 order by
    m.lschema_name,
    t.table_name,
    c.col_name;
    
select
    m.lschema_name,
    t.table_name,
    c.col_name,
    nvl(listagg(u.name,', ') within group (order by u.name),d.short_txt_value) mapek
  from
    snp_model m,
    snp_table t,
    snp_col c,
    snp_ff_valuew d,
    (
      select
          lschema_name,
          i_table,
          table_name,
          i_col,
          col_name,
          name,
          folder_name,
          coltype
      from
          (
              select
                  g.lschema_name,
                  a.i_table,
                  a.table_name,
                  b.i_col,
                  b.col_name,
                  f.name,
                  h.folder_name,
                  case when e.i_map_expr_ref is not null then 'S' else 'T' end coltype,
                  row_number() over (
                      partition by
                          g.lschema_name,
                          a.table_name,
                          b.col_name,
                          f.name
                      order by
                          h.lev desc
                  ) rownumber
              from
                  snp_table a,
                  snp_col b,
                  snp_map_ref c,
                  snp_map_attr d,
                  snp_map_expr_ref e,
                  (select * from snp_map_expr where to_char(substr(txt,1,2000)) not in ('#EDW.C_FLG_NOT_USED','#EDW.C_REF_NOT_USED','#EDW.C_REF_NOT_USED /*nem tudjuk a forrását*/')) e1,
                  snp_mapping f,
                  snp_model g,
                  (
                      select
                          a.i_folder,
                          sys_connect_by_path(folder_name,'/') folder_name,
                          level lev
                      from
                          snp_folder a
                      connect by
                          prior a.i_folder = par_i_folder
                  ) h
              where
                  b.i_table = a.i_table and
                  c.i_ref_id = b.i_col and
                  d.i_map_ref = c.i_map_ref and
                  e.i_ref_map_attr (+)= d.i_map_attr and
                  e1.i_owner_map_attr (+)= d.i_map_attr and
                  e1.txt (+) is not null and
                  f.i_mapping = c.i_owner_mapping and
                  g.i_mod = a.i_mod and
                  h.i_folder = f.i_folder and
                  (
                      e.i_map_expr_ref is not null or
                      e1.i_map_expr is not null
                  ) 
          )
      where
          rownumber = 1
    ) u
 where
    m.lschema_name like 'EDW%' and
    m.lschema_name not like 'EDW_DW%' and
    m.lschema_name not like 'EDW_PA%' and
    t.i_mod = m.i_mod and
    c.i_table = t.i_table and
    c.col_name not in ('LOAD_ID','EFFECTIVE_LOAD_DATE','ROWID') and
    d.i_instance (+) = c.i_col and
    d.ff_code (+) = 'NOT_USED_IN_DW' and
    u.i_table (+) = c.i_table and
    u.i_col (+) = c.i_col and
    u.coltype (+) = 'S'
 group by
    m.lschema_name,
    t.table_name,
    c.col_name,
    d.short_txt_value
 order by
    m.lschema_name,
    t.table_name,
    c.col_name;    