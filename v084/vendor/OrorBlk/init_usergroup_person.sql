

insert into usergroups (id,code,name,expiredate)
values(1,'1','system','2099/12/31')

insert into persons (id,code,name,expiredate,usergroups_id)
values(1,'1','system','2099/12/31',1)
;
create or replace view r_usergroups
as select id,code usergroup_code,name usergroup_name from usergroups
where expiredate > sysdate
;
create or replace view r_persons
as select a.id person_id,a.code person_code,a.name person_name,a.email person_email, 
   a.remark person_remark,
   b.id usergroup_id,b.code usergroup_code,b.name usergroup_name
from persons a,usergroups b
where a.expiredate > sysdate and UserGroups_id = b.id
;
create sequence  sessioncounters_seq

