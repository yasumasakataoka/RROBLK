

insert into usergroups (id,code,name,expiredate)
values(1,'1','system','2099/12/31')

insert into persons (id,code,name,expiredate,usergroups_id)
values(1,'1','system','2099/12/31',1)

create view r_usergroups
as select id,code usergroup_code,name usergroup_name from usergroups
where expiredate > sysdate

create view r_persons
as select a.id,a.code person_code,a.name person_name,
   b.id usergroup_id,usergroup_code,usergroup_name 
from persons a,r_usergroups b
where a.expiredate > sysdate


create sequence  sessioncounters_seq

