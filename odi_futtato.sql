alter session set nls_date_format='YYYY.MM.DD. HH24:MI:SS';

begin
  lp_executer.execute_load_plan (p_load_plan_name => 'LP_EDW_LOAD',p_top_load_id => mt_loadid_seq.nextval,p_parameters => 'GLOBAL.P_EFFECTIVE_LOAD_DATE=20160831000000');
end;
/

begin
  lp_executer.start_background_processes;
end;
/

begin
  lp_executer.abort_lp_execution(p_top_load_id => 17);
end;
/

begin
  lp_executer.delete_lp_execution(p_top_load_id => 17,p_force => true);
end;
/

begin
  lp_executer.retry_step_execution(p_load_id => 58,p_force => true);
end;
/
    
begin
  lp_executer.skip_step_execution(p_load_id => 3079,p_force => true);
end;
/
    
select object_long_name, status, load_id, top_load_id, error_message, external_session_id AS odi_session_id, sid, execution_start_time from mt_lp_current_executions 
where object_type_name = 'SCENARIO'
and nvl(status,'-') not in  ('DONE','SKIPPED')
order by 2,1;

select * from mt_lp_current_executions 
where object_type_name = 'SCENARIO'
and status = 'ERROR'
order by 2,1;

select status,top_load_id,count(1) from mt_lp_current_executions 
where object_type_name = 'SCENARIO'
group by status,top_load_id
order by status,top_load_id;

declare
  l_session_id number;
begin
  l_session_id := lp_executer.run_standalone_scenario(p_scen_name => 'MAP_SYM_FMCOUN_DW_COUNTR', p_scen_version => '001',  p_instance_name => 'EDWD10',  p_scen_parameters => 'GLOBAL.P_EFFECTIVE_LOAD_DATE=20160926000000');
end;
/