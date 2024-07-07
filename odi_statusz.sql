-- Státusz
select case mod_name when 'WLYZI' then 'WLYZA' else mod_name end ||case when mod_name = 'SYMBOLS' then ' '||substr(table_name,5,2) end rendszer, round(nvl(sum(case when used_fl = 'Y' then 1 end),0) / sum(1) * 100)||'% ('||nvl(sum(case when used_fl = 'Y' then 1 end),0)||'/'||sum(1)||')' mapping
from (
select m.mod_name, t.table_name, max(case when r.i_ref_id is not null then 'Y' else 'N' end) used_fl
from snp_table t, snp_model m, snp_mod_folder f, (select * from snp_map_ref sr, snp_mapping sm, snp_folder sf where adapter_intf_type = 'IDataStore' and sr.i_owner_mapping = sm.i_mapping and sm.i_folder = sf.i_folder and sf.folder_name = 'Landing area to DW layer') r
where m.i_mod_folder = f.i_mod_folder
and f.mod_folder_name = 'EDW'
and t.i_mod = m.i_mod
and m.mod_name not in ('DW','DW_SRC')
and t.table_name not in ('SYM_FM_CONTACT_TYPE','SYM_FM_REF_CODE')
and t.i_table = r.i_ref_id (+)
group by m.mod_name, t.table_name
)
group by case mod_name when 'WLYZI' then 'WLYZA' else mod_name end||case when mod_name = 'SYMBOLS' then ' '||substr(table_name,5,2) end
order by case mod_name when 'WLYZI' then 'WLYZA' else mod_name end||case when mod_name = 'SYMBOLS' then ' '||substr(table_name,5,2) end;

--select t.table_name tabla, sum(case when r.i_ref_id is not null then 1 end) hasznalt, listagg(map_name,',') within group (order by map_name) mapek
select subject_area, round(nvl(sum(case when used_fl = 'Y' then 1 end),0) / sum(1) * 100)||'% ('||nvl(sum(case when used_fl = 'Y' then 1 end),0)||'/'||sum(1)||')' mapping
from (
select substr(to_char(h.full_text),instr(to_char(h.full_text),'Subject area:')+13,instr(to_char(h.full_text),chr(10),1,2)-instr(to_char(h.full_text),'Subject area:')-13) subject_area,
       t.table_name,
       max(case when r.i_ref_id is not null then 'Y' else 'N' end) used_fl
from snp_table t, snp_model m, snp_mod_folder f, snp_txt_header h,
                               (
                                          select i_ref_id, a.name map_name
                                          from
                                              snp_mapping a,
                                              snp_map_comp b,
                                              snp_map_cp d,
                                              snp_map_ref r,
                                              snp_map_conn n1,
                                              snp_map_conn n2,
                                              snp_folder f
                                          where
                                              b.i_owner_mapping = a.i_mapping and
                                              d.i_owner_map_comp = b.i_map_comp and
                                              r.i_map_ref = b.i_map_ref and
                                              n1.i_start_map_cp (+) = d.i_map_cp and
                                              n1.i_map_conn is null and
                                              n2.i_end_map_cp (+) = d.i_map_cp and
                                              n2.i_map_conn is not null and
                                              a.name like 'MAP_%' and
                                              a.i_folder = f.i_folder and
                                              f.folder_name = 'Landing area to DW layer'
                               ) r
where m.i_mod_folder = f.i_mod_folder
and mod_folder_name = 'EDW'
and t.i_mod = m.i_mod
and m.mod_name = 'DW'
and t.table_name not in ('CLASSIFICATION_SCHEME','COUNTR_X_REGION_RLTNP','REGION')
and t.i_table = r.i_ref_id (+)
and t.i_txt_desc = h.i_txt (+)
group by substr(to_char(h.full_text),instr(to_char(h.full_text),'Subject area:')+13,instr(to_char(h.full_text),chr(10),1,2)-instr(to_char(h.full_text),'Subject area:')-13),t.table_name
) 
where subject_area not in ('Technical')
group by subject_area
order by subject_area;

-- Adatkör táblák
select substr(to_char(h.full_text),instr(to_char(h.full_text),'Subject area:')+13,instr(to_char(h.full_text),chr(10),1,2)-instr(to_char(h.full_text),'Subject area:')-13) subject_area,
       t.table_name
from snp_table t, snp_model m, snp_mod_folder f, snp_txt_header h
where m.i_mod_folder = f.i_mod_folder
and mod_folder_name = 'EDW'
and t.i_mod = m.i_mod
and m.mod_name = 'DW'
and t.i_txt_desc = h.i_txt (+)
order by 1,2;

