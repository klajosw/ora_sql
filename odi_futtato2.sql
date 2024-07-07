alter session set nls_date_format='YYYY.MM.DD. HH24:MI:SS';



--A pontosvesszõ direkt hiányzik innen, hogy a véletlenül az egész fájlt futtató parancs ne tudjon új futást indítani.
alter session set nls_date_format='YYYY.MM.DD. HH24:MI:SS'

begin
  --lp_executer.execute_load_plan (p_load_plan_name => 'LP_EDW_LOAD',p_top_load_id => mt_loadid_seq.nextval,p_parameters => 'GLOBAL.P_EFFECTIVE_LOAD_DATE=20160831000000');
  if '&DO_YOU_REALLY_WANT_TO_RUN_WHOLE_LOAD_PLAN' = 'YES' then
    dbms_output.put_line('&LOAD_PLAN_NAME' || ' started at ' || to_char(sysdate,'YYYY.MM.DD. HH24:MI:SS'));
    LP_EXECUTER.execute_load_plan (  P_LOAD_PLAN_NAME => '&LOAD_PLAN_NAME',
                                     P_TOP_LOAD_ID => mt_loadid_seq.nextval,
                                     P_PARAMETERS => 'GLOBAL.P_EFFECTIVE_LOAD_DATE=20180305000000' || '#|#' || 
                                                     'GLOBAL.P_IFRS_EFFECTIVE_LOAD_DATE=20180302000000#|#' || 
                                                     'GLOBAL.P_LDS_VALUE_DATE=20180228000000'
                                                     ,
                                     P_RERUN_FL => 'Y',
                                     P_OMIT_LOAD_BALANCER_FL => 'N',
                                     P_LOGICAL_AGENT => 'EDW',
                                     P_EFFECTIVE_LOAD_DATE => DATE'2018-03-05',
                                     P_DELETE_AFTER_DONE_FL => 'Y'
                                  ) ;
  else
    dbms_output.put_line('&LOAD_PLAN_NAME' || ' NOT started at ' || to_char(sysdate,'YYYY.MM.DD. HH24:MI:SS') || ' answer: ' ||'&DO_YOU_REALLY_WANT_TO_RUN_WHOLE_LOAD_PLAN');
  end if;
end;
/

begin
  lp_executer.start_background_processes;
end;
/

begin
  lp_executer.abort_lp_execution(p_top_load_id => 48173);
end;
/

begin
  lp_executer.delete_lp_execution(p_top_load_id => 48173);
end;
/

begin
  lp_executer.retry_step_execution(p_load_id => 51514);
end;
/
    
begin
  lp_executer.skip_step_execution(p_load_id => 61468,p_return_value => NULL);
end;
/

    
select object_long_name, status, load_id, top_load_id, error_message, external_session_id AS odi_session_id, sid, execution_start_time from mt_lp_current_executions 
where object_type_name = 'SCENARIO'
and nvl(status,'-') not in  ('DONE','SKIPPED')
order by 2,1;

select * from mt_lp_current_executions 
where object_type_name = 'SCENARIO'
--and status = 'ERROR'
order by 2,1;

select status,top_load_id,count(1) from mt_lp_current_executions 
where object_type_name = 'SCENARIO'
group by status,top_load_id
order by status,top_load_id;

declare
  l_session_id number;
begin
  l_session_id := lp_executer.run_standalone_scenario(p_scen_name => 'MAP_DW_ARRANG_PLD_LDSDEAL_BASE', 
                                                      p_scen_version => '001',  
                                                      p_instance_name => 'EDWPROT1',  
                                                      p_scen_parameters => 'GLOBAL.P_EFFECTIVE_LOAD_DATE=20180305000000' 
                                                                           --|| '#|#' || 'GLOBAL.P_IFRS_EFFECTIVE_LOAD_DATE=20180302000000'
                                                                           || '#|#' || 'GLOBAL.P_LDS_VALUE_DATE=20180228000000'
                                                                           --|| '#|#' || 'GLOBAL.P_ARCHIVAL_GROUP_NAME=''LDS'''
                                                                           ,
                                                      p_context_name => null,
                                                      p_logical_agent => 'EDW',
													  p_effective_load_date => DATE'2018-02-28',
                                                      p_async_fl => false);
end;
/

declare
l_session_id number;
begin
l_session_id := lp_executer.run_standalone_scenario(p_scen_name => 'MAP_DW_ARRACT_PLD_LDSWREI',
                                                    p_scen_version => '001',
                                                    p_instance_name => 'EDWPROT1',
                                                    p_scen_parameters => 'GLOBAL.P_EFFECTIVE_LOAD_DATE=20180705000000#|#GLOBAL.P_LDS_VALUE_DATE=20180630000000',
                                                    p_context_name => NULL,
                                                    p_logical_agent => 'EDW',
                                                    p_async_fl => FALSE);
end;
/


insert into mt_lp_step_parameters values('LP_PLD_LOAD:MAP_DW_ARRANG_PLD_LDSDEAL_CUST','NEVER_RUN',null);

select * 
  from mt_lp_step_parameters
 where object_long_name like '%_LDS_LOAD%'
 for update;

begin
  kill_odi_meta_session(p_sid => 2213,p_serial => 11566);
end;


select s.sess_name, l.*, s.startup_variables from EBH_ODI_REPO.snp_sess_task_log l ,EBH_ODI_REPO.snp_session s 
where l.sess_no = s.sess_no 
and (sess_name like '%MAP_SYM_FMCOLL_DW_COREIT%' )
--and trim(def_txt) is not null 
--and trim(def_txt) like '%MAN_SELL_PRICES_CUP%'
--and task_beg > trunc(sysdate) - 2
--and task_beg between date '2017-02-07' and date '2017-02-10'
order by 2 desc,5 desc;



select * from mt_lp_all_executions 
where object_name like 'LP_BL_EDW_LOAD'
order by 2,1 desc;

select s.sess_name, l.*, s.startup_variables from EBH_ODI_REPO.snp_sess_task_log l ,EBH_ODI_REPO.snp_session s 
where l.sess_no = s.sess_no 
and (sess_name like '%LP_BL_EDW_LOAD%' )
order by 2 desc,5 desc;
