drop sequence SIO_R_SCREENS_seq
;  
create sequence SIO_R_SCREENS_seq
;
drop sequence SESSIONCOUNTERS_SEQ
;  
create sequence SESSIONCOUNTERS_SEQ
;
drop sequence screenid_seq
;  
create sequence screenid_seq
;

-----  ‰æ–Ê–¼ƒZƒbƒg
truncate table  screens

insert into screens(id,Type,Name,ViewName,Expiredate,Remark,
                    Persons_id_Upd,created_at,Update_at,
                    code)
select screens_seq.nextval,'A',view_name||'‰æ–Ê',view_name,'2030/12/31','auto_crt',
       1, sysdate,sysdate,
       substr(view_name,3,3)
 from   user_views a 
where not exists   
      (select 1 from screens b where a.view_name = b.viewname)
and view_name like 'R_%'



