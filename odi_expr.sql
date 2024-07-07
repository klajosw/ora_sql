select
    a.name map_name,
    b.name comp_name,
    c.name comp_type,
    e.name attr_name,
    to_char(substr(f.txt,1,3000)) expr,
    g.folder_name,
    a.global_id
from
    snp_mapping a,
    snp_map_comp b,
    snp_map_comp_type c,
    snp_map_cp d,
    snp_map_attr e,
    snp_map_expr f,
    snp_folder g
where
    g.i_folder = a.i_folder and
    b.i_owner_mapping = a.i_mapping and
    c.i_map_comp_type = b.i_map_comp_type and
    d.i_owner_map_comp = b.i_map_comp and
    e.i_owner_map_cp = d.i_map_cp and
    f.i_owner_map_attr = e.i_map_attr and
    upper(f.txt) like '%\%%' escape '\' and
    g.folder_name != 'Sandbox' 
union all
select
    a.name,
    b.name,
    c.name,
    null,
    to_char(substr(f.txt,1,3000)),
    g.folder_name,
    a.global_id
from
    snp_mapping a,
    snp_map_comp b,
    snp_map_comp_type c,
    snp_map_cp d,
    snp_map_prop e,
    snp_map_expr f,
    snp_folder g
where
    g.i_folder = a.i_folder and
    b.i_owner_mapping = a.i_mapping and
    c.i_map_comp_type = b.i_map_comp_type and
    d.i_owner_map_comp = b.i_map_comp and
    e.i_map_cp = d.i_map_cp and
    f.i_owner_map_prop = e.i_map_prop and
    upper(f.txt) like '%\%%' escape '\' and
    g.folder_name != 'Sandbox'
union all
select
    a.name,
    b.name,
    c.name,
    null,
    to_char(substr(e.txt,1,3000)),
    g.folder_name,
    a.global_id
from
    snp_mapping a,
    snp_map_comp b,
    snp_map_comp_type c,
    snp_map_prop d,
    snp_map_expr e,
    snp_folder g
where
    g.i_folder = a.i_folder and
    b.i_owner_mapping = a.i_mapping and
    c.i_map_comp_type = b.i_map_comp_type and
    d.i_map_comp = b.i_map_comp and
    e.i_owner_map_prop = d.i_map_prop and
    upper(e.txt) like '%\%%' escape '\' and
    g.folder_name != 'Sandbox'
union all
select
    a.name,
    b.name,
    c.name,
    e.name,
    to_char(substr(f.txt,1,3000)),
    g.folder_name,
    a.global_id
from
    snp_mapping a,
    snp_map_comp b,
    snp_map_comp_type c,
    snp_map_cp d,
    snp_map_attr e,
    snp_map_prop p,
    snp_map_expr f,
    snp_folder g
where
    g.i_folder = a.i_folder and
    b.i_owner_mapping = a.i_mapping and
    c.i_map_comp_type = b.i_map_comp_type and
    b.i_map_comp = d.i_owner_map_comp and
    d.i_map_cp = e.i_owner_map_cp and
    e.i_map_attr = p.i_map_attr and
    f.i_owner_map_prop = p.i_map_prop and
    upper(f.txt) like '%\%%' escape '\' and
    g.folder_name != 'Sandbox'
order by 1,2,3,4